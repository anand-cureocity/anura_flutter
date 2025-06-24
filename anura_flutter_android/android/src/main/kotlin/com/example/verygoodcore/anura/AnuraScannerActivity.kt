package com.example.verygoodcore.anura

import com.example.verygoodcore.BuildConfig
import com.example.verygoodcore.R
import com.example.verygoodcore.anura.utils.KEY_DFX_EXTRACTION_LIBRARY_STUDY_CONFIG
import com.example.verygoodcore.anura.utils.KEY_MEASUREMENT_RESULTS
import com.example.verygoodcore.anura.utils.SharedPreferencesHelper
import ai.nuralogix.anuracream.ui.views.MeasurementView
import ai.nuralogix.anuracream.utils.DisplayUtil.maximizeScreenBrightness
import ai.nuralogix.anuracream.utils.DisplayUtil.resumeScreenBrightness
import ai.nuralogix.anurasdk.config.CameraConfiguration
import ai.nuralogix.anurasdk.config.Configuration
import ai.nuralogix.anurasdk.config.DfxPipeConfiguration
import ai.nuralogix.anurasdk.config.RenderingVideoSinkConfig
import ai.nuralogix.anurasdk.core.Core
import ai.nuralogix.anurasdk.core.MeasurementPipeline
import ai.nuralogix.anurasdk.core.MeasurementPipelineListener
import ai.nuralogix.anurasdk.core.VideoFormat
import ai.nuralogix.anurasdk.core.entity.MeasurementQuestionnaire
import ai.nuralogix.anurasdk.core.result.MeasurementResults
import ai.nuralogix.anurasdk.core.states.MeasurementState
import ai.nuralogix.anurasdk.error.AnuraError
import ai.nuralogix.anurasdk.face.FaceTrackerAdapter
import ai.nuralogix.anurasdk.face.MediaPipeFaceTracker
import ai.nuralogix.anurasdk.render.Render
import ai.nuralogix.anurasdk.utils.AnuLogUtil
import ai.nuralogix.anurasdk.utils.Countdown
import ai.nuralogix.anurasdk.utils.DCResult
import ai.nuralogix.anurasdk.utils.DefaultCountdown
import ai.nuralogix.anurasdk.utils.ImageUtils
import ai.nuralogix.anurasdk.views.AbstractTrackerView
import ai.nuralogix.anurasdk.views.utils.MeasurementUIConfiguration
import ai.nuralogix.dfx.ChunkPayload
import ai.nuralogix.dfx.ConstraintResult
import ai.nuralogix.dfx.ConstraintResult.ConstraintReason
//import android.content.Intent
import android.content.res.Resources
import android.opengl.GLSurfaceView.Renderer
//import android.os.Bundle
import android.util.Log
import android.view.Window
import android.view.WindowManager
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.LiveData
import com.example.verygoodcore.anura.viewmodel.ExampleStartViewModel
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi
import kotlin.math.max
import androidx.activity.viewModels
import com.example.verygoodcore.databinding.AnuraScannerBinding
import kotlin.system.exitProcess

import android.Manifest
import android.content.pm.PackageManager
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.coroutines.launch
import android.os.Bundle


class AnuraScannerActivity :  AppCompatActivity(),
 MeasurementPipelineListener,
  AbstractTrackerView.TrackerViewListener {

  companion object {
   const val TAG = "AnuraMeasurementActivity"
   /**
    * Generally, the front-facing camera sensor is rotated, and so the width and height are
    * reversed. You may adjust IMAGE_WIDTH and IMAGE_HEIGHT to suit your application and
    * hardware.
    */
   var IMAGE_WIDTH = 640.0f
   var IMAGE_HEIGHT = 480.0f

   /**
    * Measurement duration is typically set to 30 seconds, with a total of 6 chunks that are
    * 5 seconds each. This allows the application to get measurement results every 5 seconds
    */
   var MEASUREMENT_DURATION = 30.0
   var TOTAL_NUMBER_CHUNKS = 6

  }

  /**
   * [MeasurementState] reflects the current state of the measurement. This is used to manage the
   * state of the UI.
   */
  private var measurementViewState: MeasurementState = MeasurementState.Off

  /**
   * Core manages the threads and dispatching work to the various components of Anura Core SDK.
   */
  private lateinit var core: Core

  /**
   * [MeasurementPipeline] connects the various components of Anura Core SDK, from fetching camera
   * video frames all the way through rendering the video in the UI. It also manages the
   * measurement state.
   */
  private lateinit var measurementPipeline: MeasurementPipeline

  /**
   * [FaceTrackerAdapter] is responsible for integrating a face tracker component to Anura Core.
   * Included in Anura Core SDK is a FaceTrackerAdapter for MediaPipe FaceMesh from Google.
   *
   * Earlier versions of Anura Core SDK included Visage FaceTrack. If you still would like to use
   * Visage FaceTrack, please refer to the 2.4.0 Migration Guide.
   */
  private lateinit var faceTracker: FaceTrackerAdapter

  /**
   * [VideoFormat] specifies the format of the camera video frames
   */
  private lateinit var videoFormat: VideoFormat

  /**
   * [Render] is responsible for rendering the camera video frames in the UI. Anura Core SDK
   * includes a Render class based on OpenGL
   */
  private lateinit var render: Render

  /**
   * [MeasurementView] displays the various UI elements on top of the camera view
   * (measurement outline, histograms, heart image, etc)
   */
  private lateinit var measurementView: MeasurementView

  /**
   * [MeasurementUIConfiguration] configures the various aspects of MeasurementView
   */
  private lateinit var measurementUIConfig: MeasurementUIConfiguration

  /**
   * Handles the "3...2...1..." measurementStartCountdown when the measurement is about
   * to start
   */
  private lateinit var measurementStartCountdown: Countdown

  /**
   * This is an example [AlertDialog] that gets displayed as a loading indicator while the
   * measurement data is being processed on DeepAffex Cloud
   */
  private lateinit var analyzingAlertDialog: AlertDialog

  /**
   * This is the saved config data binary that is used to initalize DeepAffex Extraction Library
   * based on the DeepAffex Cloud study ID of your application.
   */
  private var deepAffexExtractionLibraryStudyConfigData
          by SharedPreferencesHelper(KEY_DFX_EXTRACTION_LIBRARY_STUDY_CONFIG, "")

  /**
   * This is used to keep track of network state and inform users when the network is unavailable
   */
  private var isNetworkAvailable = true

 private val binding by lazy { AnuraScannerBinding.inflate(layoutInflater) }

 private val exampleStartViewModel: ExampleStartViewModel
         by viewModels { ExampleStartViewModel.Factory }

  //region Common Methods
  /**
   * This method will get called when measurement is complete DeepAffex Cloud has finished
   * processing the measurement data
   *
   * Here your application can save the data from [MeasurementResults]. As an example, here the
   * results will be displayed in a simple list in a new activity
   */
  private fun handleMeasurementResultsComplete(results: MeasurementResults) {
   /**
    * Hide the "Analyzing..." loading indicator
    */
   dismissAnalyzingAlertDialogIfVisible()

   /**
    * Display MeasurementResults in a new [ExampleResultsActivity] by sending it as extras in
    * the intent
    */
   Log.d(TAG, "results=$results")
//   val intent = Intent(this, ExampleResultsActivity::class.java)
//   intent.putExtra(KEY_MEASUREMENT_RESULTS, results)
//   startActivity(intent)
  }

  /**
   * Start the measurement. This method will only start the measurement if the state is in
   * [MeasurementState.ReadyToMeasure]. Starting a measurement makes a call to DeepAffex Cloud API
   * and creates a new Measurement ID.
   *
   * Reference: https://dfxapiversion10.docs.apiary.io/#reference/0/measurements/create
   */
  private fun startMeasurement() {

   if (!this::core.isInitialized) {
    return
   }

      var userData = getIntent().getExtras()
      val sex = userData!!.getString("sex")
      val height = userData!!.getInt("height")
      val weight = userData!!.getInt("weight")
      val age = userData!!.getInt("age")

   var measurementQuestionnaire = MeasurementQuestionnaire().apply {
    setSexAssignedAtBirth(sex.toString())
    setAge(age)
    setHeightInCm(height)
    setWeightInKg(weight)
   }


   val status = measurementPipeline.startMeasurement(
    measurementQuestionnaire,
    BuildConfig.DFX_STUDY_ID,
    "Guest"
   )
Log.d(TAG, "status=$status")
   if (status == AnuraError.Core.OK) {
    setupMeasurementViewForStartMeasurement()
   }
  }

  /**
   * Stop the current active measurement. This method will only stop the measurement if the state
   * is in [MeasurementState.Measuring] or [MeasurementState.Analyzing]
   */
  private fun stopMeasurement() = runOnUiThread {
   if (!this::core.isInitialized) {
    return@runOnUiThread
   }

   val status = measurementPipeline.stopMeasurement()

   if (status == AnuraError.Core.OK) {
    dismissAnalyzingAlertDialogIfVisible()
    resetMeasurementView()
   }
  }

  /**
   * Handle a new [MeasurementState] and update the UI accordingly
   */
  private fun handleMeasurementViewState(state: MeasurementState) = runOnUiThread {
   /**
    * If there's no internet connection detected, show error
    */
   if (!isNetworkAvailable &&
    (state == MeasurementState.Idle
            || state == MeasurementState.Extracting
            || state == MeasurementState.Hold
            || state == MeasurementState.ReadyToMeasure)
   ) {
    setMeasurementErrorMsg(resources.getString(R.string.ERR_CONSTRAINT_NO_NETWORK))
    return@runOnUiThread
   }

   /**
    * If the new state is the same as the previous state, do nothing
    */
   if (state == measurementViewState) return@runOnUiThread

   when (state) {
    /**
     * [MeasurementPipeline] is off. Shutdown everything.
     */
    MeasurementState.Off -> {
     resetMeasurementView()
    }

    /**
     * Calibrating is reserved for a future version of Anura Core SDK.
     */
    MeasurementState.Calibrating -> {
     // reserved
    }

    /**
     * Locked occurs after a measurement cancellation to show the user feedback and allow
     * time for the measurement to reset.
     */
    MeasurementState.Locked -> {
     resetMeasurementView()
    }

    /**
     * Idle is when there's no face is detected in the camera.
     */
    MeasurementState.Idle -> {
     resetMeasurementView()
     measurementView.promptMsg = resources.getString(R.string.MEASURING_MSG_DEFAULT)
    }

    /**
     * Extracting is when a face is detected, but the user isn't yet in the correct
     * position based on the active DeepAffex Extraction Library constraints.
     */
    MeasurementState.Extracting -> {
     resetMeasurementView()
     maximizeScreenBrightness(this)
     measurementView.tracker.showHistograms(measurementUIConfig.showHistograms)
    }

    /**
     * Hold is when the user is in the correct position. That's when the lighting quality
     * stars appear along with a "Perfect! Hold still" status message appears on the screen.
     */
    MeasurementState.Hold -> {
     prepareViewForHoldState()
    }

    /**
     * ReadyToMeasure occurs after the Hold state if the user is still in the correct
     * position and ready to measure. This is when the "3...2...1..." countdown starts.
     */
    MeasurementState.ReadyToMeasure -> {
     measurementStartCountdown.start()
     measurementView.promptMsg = resources.getString(R.string.MEASURING_COUNTDOWN)
    }

    /**
     * Measuring reflects an active measurement.
     */
    MeasurementState.Measuring -> {
     with(measurementView) {
      showHeartRate(true)
      setHeartRate("--")
      promptMsg = ""
     }
    }

    /**
     * Analyzing occurs after the Measuring state when extraction is complete. In this
     * state, DeepAffex Cloud is processing the measurement data and the application is
     * waiting for results.
     */
    MeasurementState.Analyzing -> {
     resumeScreenBrightness(this)
     resetMeasurementView()
     displayAnalyzingDialog()
    }

    /**
     * Complete indicates a complete measurement, with results being available if the
     * measurement passed the quality checks on DeepAffex Cloud.
     */
    MeasurementState.Complete -> {
     stopMeasurement()
    }

    /**
     * Failure occurs only after a Measuring state if an error occurs during a measurement.
     */
    MeasurementState.Failure -> {
     stopMeasurement()
    }
   }

   measurementViewState = state
  }

  /**
   * This method is called after MeasurementPipeline and MeasurementView have finished setting up.
   * As an example, this method simply displays the version number of DeepAffex Extraction Library
   */
  private fun setupCustomViews() {
//   val dfxIDText = findViewById<TextView>(R.id.dfx_sdk_version)
//   dfxIDText.setTextColor(measurementUIConfig.statusMessagesTextColor)
//   dfxIDText.text = getString(R.string.dfx_id_version, core.dfxSdkID, core.coreSdkVersion)
  }

  //endregion Common Methods

  /**
   * Configures MeasurementView for the Hold State.
   */
  private fun prepareViewForHoldState() = runOnUiThread {
   measurementView.tracker.flipTrackerColor(true)
   with(measurementView) {
    promptMsg = resources.getString(R.string.MEASURING_PERFECT)
    tracker.showHistograms(measurementUIConfig.showHistograms)
    showHeartRate(false)
    setStars(0f)
    showStars(true)
   }
  }

  //region MeasurementPipelineListener

  /**
   * [MeasurementPipeline] callback that provides information about the network connection status
   */
  override fun onNetworkChange(isAvailable: Boolean) {
   isNetworkAvailable = isAvailable
   if (!isAvailable && (measurementViewState != MeasurementState.ReadyToMeasure
            && measurementViewState != MeasurementState.Measuring
            && measurementViewState != MeasurementState.Analyzing)
   ) {
    setMeasurementErrorMsg(resources.getString(R.string.ERR_CONSTRAINT_NO_NETWORK))
   }
  }

  /**
   * [MeasurementPipeline] callback to provide a way to observe [MeasurementState].
   */
  override fun onMeasurementStateLiveData(measurementState: LiveData<MeasurementState>?) {
   measurementState?.observe(this) { newState: MeasurementState ->
    handleMeasurementViewState(state = newState)
   }
  }

  /**
   * [MeasurementPipeline] callback to provide the measurementID as soon as
   * it is available.
   */
  override fun onMeasurementCreated(measurementID: String?) {
   Log.d(TAG, "measurementID:$measurementID")
  }

  /**
   * [MeasurementPipeline] callback to get the current camera parameters and lighting quality
   * score. [lightQAS] can be used to display and update the stars on the measurement UI.
   */
  override fun onMeasurementLightParam(
   dcResult: DCResult,
   ISO: Int,
   maxISO: Int,
   exposureDuration: Long,
   aeCompensation: Int,
   lightQAS: Float
  ) = runOnUiThread {
   measurementView.setStars(lightQAS)
  }

  /**
   * [MeasurementPipeline] callback to get the current histograms for display on the measurement
   * UI. If you set [RenderingVideoSinkConfig.RuntimeKey.UPDATE_HISTOGRAM] to `FALSE`, this method
   * will not be called.
   */
  override fun onHistogramReceived(regionCenters: FloatArray, histograms: FloatArray) =
   runOnUiThread {
    Log.d(TAG, "onHistogramReceived")
    measurementView.tracker.setHistograms(histograms, regionCenters)
   }

  /**
   * [MeasurementPipeline] callback to get the current violations of DeepAffex Extraction
   * Library's Constraint system. For more information on Constraints, please refer to DeepAffex
   * Developer Guide:
   *
   * https://docs.deepaffex.ai/guide/sdk/5_constraints.html
   */
  override fun onMeasurementConstraint(
   isMeasuring: Boolean,
   status: ConstraintResult.ConstraintStatus,
   constraints: MutableMap<String, ConstraintResult.ConstraintStatus>
  ) {

   /**
    * Parse the constraint violation reason
    */
   var constraintReason: ConstraintReason = ConstraintReason.UNKNOWN
   constraints.forEach {
    constraintReason = ConstraintResult.getConstraintReasonFromString(it.key)
   }

   /**
    * Update the constraint message on the UI
    */
   setConstraintMessage(isMeasuring, status, constraintReason)
  }

  /**
   * [MeasurementPipeline] callback to get the current [MeasurementResults] during a measurement.
   * For a typical 30-second measurement of 6 chunks that are 5 seconds each, this method will be
   * called 5 times.
   *
   * @param payload   The payload data generated by DeepAffex Extraction Library and sent to
   *                  DeepAffex Cloud for processing
   * @param results   A [MeasurementResults] instance containing results of the current
   *                  measurement so far
   */
  override fun onMeasurementPartialResult(payload: ChunkPayload?, results: MeasurementResults) {
   Log.d(TAG, "onMeasurementPartialResult - " +
           "MeasurementID ${results.measurementID} - " +
           "${results.chunkOrder}")

   /**
    * Check the SNR of the measurement so far
    */
   handleResultSNR(results, false)
  }

  /**
   * [MeasurementPipeline] callback to get the current [MeasurementResults] when a measurement is
   * complete.
   *
   * @param payload   The last chunk of the payload data generated by DeepAffex Extraction Library
   * @param results   A [MeasurementResults] instance containing results of the completed
   *                  measurement
   */
  override fun onMeasurementDone(payload: ChunkPayload?, results: MeasurementResults) {
   Log.d(TAG, "onMeasurementDone - " +
           "MeasurementID ${results.measurementID} - " +
           "${results.chunkOrder}")

   /**
    * Check the SNR of the measurement
    */
   handleResultSNR(results, true)
  }

  /**
   * [MeasurementPipeline] callback to handle any errors during a measurement
   */
  override fun onMeasurementError(error: AnuraError) {
   Log.d(TAG, "onMeasurementError")
   handleMeasurementError(error)
  }

  /**
   * [MeasurementPipeline] callback to report back the progress of a measurement during
   * [MeasurementState.Measuring]. The parameter [progressPercent] can be used to update the UI
   * and show feedback to the user on the current progress.
   */
  override fun onMeasurementProgress(progressPercent: Float, frameRate: Float) {
   measurementView.tracker.setMeasurementProgress(progressPercent)
  }
  //endregion MeasurementPipelineListener

  //region pipeline initialization

  /**
   * Setup and initialize [MeasurementPipeline]
   */
  private fun setupMeasurementPipeline() {
   Log.d(TAG, "initPipeline")

   core = Core.createAnuraCore(this)

   setupFaceTracker()
   setupMeasurementDuration()
   setupCountdownTimer()
   setupRenderer()
   createMeasurementPipeline()
  }

  /**
   * Instantiate [MeasurementPipeline]
   */
  private fun createMeasurementPipeline() {
   Log.d(TAG, "createMeasurementPipeline")

   measurementPipeline =
    MeasurementPipeline.createMeasurementPipeline(
     core,
     MEASUREMENT_DURATION.toInt(),
     videoFormat,
     getStudyFileByteData(),
     render,
     getConfigurations(),
     faceTracker,
     this
    )

   measurementView.trackerImageView.setRenderer(render as Renderer)
  }

  /**
   * Load the study configuration file for DeepAffex Extraction Library from SharedPreferences
   */
  @OptIn(ExperimentalEncodingApi::class)
  private fun getStudyFileByteData(): ByteArray {
   return Base64.decode(
    deepAffexExtractionLibraryStudyConfigData,
    0,
    deepAffexExtractionLibraryStudyConfigData.length
   )
  }

  /**
   * Setup and initialize [MediaPipeFaceTracker]
   */
  private fun setupFaceTracker() {
   val display = resources.displayMetrics
   val width = display.widthPixels
   val height = display.heightPixels

   faceTracker = MediaPipeFaceTracker(core.context)
   faceTracker.setTrackingRegion(0, 0, width, height)
  }

  /**
   * Set up the [Configuration] parameters used by the various stages of [MeasurementPipeline]
   */
  private fun getConfigurations(): HashMap<String, Configuration<*, *>> {
   val configurations = HashMap<String, Configuration<*, *>>()
   val cameraConfig = getCameraConfiguration()
   val dfxPipeConfig = getDfxPipeConfiguration()
   val renderingVideoSinkConfig = getRenderingVideoSinkConfig()

   configurations[cameraConfig.id] = cameraConfig
   configurations[dfxPipeConfig.id] = dfxPipeConfig
   configurations[renderingVideoSinkConfig.id] = renderingVideoSinkConfig

   return configurations
  }

  /**
   * Create a [RenderingVideoSinkConfig]
   */
  private fun getRenderingVideoSinkConfig(): RenderingVideoSinkConfig {
   val renderingVideoSinkConfig = RenderingVideoSinkConfig(application.applicationContext, null)

   /**
    * By default, [RenderingVideoSinkConfig.RuntimeKey.UPDATE_HISTOGRAM] should be set to `false`
    * In previous versions of Anura Core SDK, this parameter was set to true.
    */
   renderingVideoSinkConfig.setRuntimeParameter(
    RenderingVideoSinkConfig.RuntimeKey.UPDATE_HISTOGRAM,
    measurementUIConfig.showHistograms.toString()
   )
   return renderingVideoSinkConfig
  }

  /**
   * Create a [DfxPipeConfiguration]. This is used to configure DeepAffex Extraction Library and
   * the Constraint System. For more information, please refer to the DeepAffex Developer Guide:
   *
   * https://docs.deepaffex.ai/guide/4_sdk.html
   */
  private fun getDfxPipeConfiguration(): DfxPipeConfiguration {
   val dfxPipeConfiguration = DfxPipeConfiguration(applicationContext, null)

   /**
    * By default, these constraints should be set to `true`;
    *  - [DfxPipeConfiguration.RuntimeKey.CHECK_FACE_DISTANCE]
    *  - [DfxPipeConfiguration.RuntimeKey.CHECK_MAX_FACE_DISTANCE]
    *  - [DfxPipeConfiguration.RuntimeKey.CHECK_FACE_CENTERED]
    *  - [DfxPipeConfiguration.RuntimeKey.CHECK_FACE_DIRECTION]
    *  - [DfxPipeConfiguration.RuntimeKey.CHECK_FACE_MOVEMENT]
    * In previous versions of Anura Core SDK, this parameter was set to false.
    */
   dfxPipeConfiguration.setRuntimeParameter(
    DfxPipeConfiguration.RuntimeKey.CHECK_FACE_DISTANCE,
    true
   )
   dfxPipeConfiguration.setRuntimeParameter(
    DfxPipeConfiguration.RuntimeKey.CHECK_MAX_FACE_DISTANCE,
    true
   )
   dfxPipeConfiguration.setRuntimeParameter(
    DfxPipeConfiguration.RuntimeKey.CHECK_FACE_CENTERED,
    true
   )
   dfxPipeConfiguration.setRuntimeParameter(
    DfxPipeConfiguration.RuntimeKey.CHECK_FACE_DIRECTION,
    true
   )
   dfxPipeConfiguration.setRuntimeParameter(
    DfxPipeConfiguration.RuntimeKey.CHECK_FACE_MOVEMENT,
    true
   )
   return dfxPipeConfiguration
  }

  private fun getCameraConfiguration(): CameraConfiguration {
   val configuration = CameraConfiguration(this, null)

   /**
    * Uncomment the line below and set the cameraId you prefer if the default one selected
    * by Anura Core SDK is incorrect
    */
   // configuration.setRuntimeParameter(CameraConfiguration.RuntimeKey.CAMERA_ID, "1")

   /**
    * Uncomment below line to set the camera flip to desired setting
    */
   // configuration.setRuntimeParameter(CameraConfiguration.RuntimeKey.CAMERA_FLIP, CameraAdapter.ADJUST_CAMERA_FLIP_FLIP)

   return configuration
  }

  /**
   * Setup the measurement duration in [DfxPipeConfiguration]. This is typically set to 30 seconds
   * with a total of 6 chunks that are 5 seconds each. This allows the application to get
   * measurement results every 5 seconds
   */
  private fun setupMeasurementDuration() {
   val dfxConfig = DfxPipeConfiguration(this, null)
   TOTAL_NUMBER_CHUNKS =
    dfxConfig.getRuntimeParameterInt(DfxPipeConfiguration.RuntimeKey.TOTAL_NUMBER_CHUNKS, 6)
   val duration = TOTAL_NUMBER_CHUNKS * dfxConfig.getRuntimeParameterFloat(
    DfxPipeConfiguration.RuntimeKey.DURATION_PER_CHUNK,
    5f
   )
   MEASUREMENT_DURATION = duration.toDouble()
   measurementView.tracker.setMeasurementDuration(duration.toDouble())
  }
  //endregion pipeline initialization

  /**
   * Resets the [MeasurementView] class configuration to its default idle state
   */
  private fun resetMeasurementView() = runOnUiThread {
   resumeScreenBrightness(this)
   measurementStartCountdown.cancel()

   with(measurementView) {
    with(tracker) {
     showMask(true)
     showMeasurementProgress(false)
     setMeasurementProgress(0.0f)
     flipTrackerColor(false)
     showHistograms(false)
    }
    reset()
    showHeartRate(false)
    showStars(false)
   }
   setupStarPositionsBasedOnScreenSize()
  }

  //region result and error handling

  /**
   * This method handles [MeasurementResults] from DeepAffex Cloud.
   * @param results    An object containing the current measurement results
   * @param isFinalResult         determines if this is the final result for the current
   *                              active measurement
   */
  private fun handleResultSNR(results: MeasurementResults, isFinalResult: Boolean) {
   val resultIndex = results.chunkOrder
   Log.d(TAG, "Current result index=$resultIndex and snr=${results.snr}")

   /**
    * Update the heart rate result on the UI
    */
   updateHeartRateResult(results)

   /**
    * Pass the SNR and chunk order to [MeasurementPipeline.shouldCancelMeasurement] to check
    * if the measurement should be cancelled early due to a failure in measurement quality
    * checks
    */
   if (measurementPipeline.shouldCancelMeasurement(results.snr, resultIndex)) {
    Log.d("handleResultSNR-shouldCancel", "stopMeasurement")
    stopMeasurement()
    setMeasurementErrorMsg(resources.getString(R.string.ERR_MSG_SNR_SHORT))
    return
   }

   /**
    * If it's the final result, pass the results to another activity for display
    */
   if (isFinalResult) {
    Log.d("handleResultSNR-isLastResult", "stopMeasurement")
    handleMeasurementResultsComplete(results)
   }
  }

  /**
   * This method handles DeepAffex Cloud network errors
   */
  private fun handleMeasurementError(error: AnuraError) = runOnUiThread {
   Log.d(TAG, "handleMeasurementError:$error")
   when (error) {
    is AnuraError.Core -> {
     val errorMessage = when (error) {
      AnuraError.Core.FACE_TRACKER_ERROR -> {
       getString(R.string.FACE_TRACKER_ERROR)
      }

      AnuraError.Core.CAMERA_NOT_SUPPORTED -> {
       getString(R.string.CAMERA_NOT_SUPPORTED_ERROR)
      }

      else -> {
       ""
      }
     }
     if (errorMessage.isNotBlank()) {
      resetMeasurementView()
      measurementView.promptMsg = errorMessage
     }
    }
    AnuraError.Network.LICENSE_EXPIRED -> {
     Toast.makeText(
      this,
      resources.getString(R.string.ERR_SERVER_CONNECTION),
      Toast.LENGTH_LONG
     ).show()
    }

    AnuraError.Network.LOW_SNR -> {
     setMeasurementErrorMsg(resources.getString(R.string.ERR_MSG_SNR_SHORT))
    }

    AnuraError.Network.DFX_VALIDATION_ERROR -> {
     setMeasurementErrorMsg(resources.getString(R.string.ERR_MSG_ANALYZER_FAILED))
    }

    AnuraError.Network.DFX_GENERAL_ERROR, AnuraError.Network.DFX_DISCONNECTED_ERROR -> {
     setMeasurementErrorMsg(resources.getString(R.string.ERR_SERVER_CONNECTION))
    }

    AnuraError.Network.DFX_REQUEST_TIMEOUT -> {
     setMeasurementErrorMsg(resources.getString(R.string.ERR_SERVER_CONNECTION))
    }

    AnuraError.Network.LICENSE_TOKEN_EXPIRED,
    AnuraError.Network.LICENSE_TOKEN_INVALID -> {
     setMeasurementErrorMsg(resources.getString(R.string.ERR_MSG_ANALYZER_FAILED))
    }

    else -> {
     setMeasurementErrorMsg(resources.getString(R.string.ERR_MSG_MEASUREMENT_FAILED))
    }
   }

   stopMeasurement()
  }

  /**
   * This method handles the DeepAffex Extraction Library's Constraint system messages and
   * displays feedback to the user in the status message area under the measurement outline
   * @param isMeasuring           A boolean that determines if the measurement is currently active
   * @param status                An enum that indicates if the current constraint status is
   *                              `GOOD`, `WARNING` or `ERROR
   * @param eReason               An object containing the reason why the Constraints system
   *                              was triggered
   */
  private fun setConstraintMessage(
   isMeasuring: Boolean,
   status: ConstraintResult.ConstraintStatus,
   eReason: ConstraintReason
  ) {

   var constraintMessage = ""

   when (eReason) {
    /**
     * Default prompt when there's no face or image
     */
    ConstraintReason.UNKNOWN,
    ConstraintReason.IMAGE_EMPTY ->
     constraintMessage = resources.getString(R.string.MEASURING_MSG_DEFAULT)

    /**
     * Prompt when face moves outside the camera frame
     */
    ConstraintReason.FACE_OFFTARGET,
    ConstraintReason.FACE_NONE ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_POSITION)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_POSITION)
     }

    /**
     * Prompt when the face is too far
     */
    ConstraintReason.FACE_FAR ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_TOO_FAR)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_TOO_FAR)
     }

    /**
     * Prompt when there's too much movement
     */
    ConstraintReason.FACE_MOVEMENT,
    ConstraintReason.CAMERA_MOVEMENT ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_MOVEMENT)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_MOVEMENT)
     }

    /**
     * Prompt when camera frames-per-second is too low
     */
    ConstraintReason.LOW_FPS ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_FPS)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_FPS)
     }

    /**
     * Prompt when there's too much light
     */
    ConstraintReason.IMAGE_BRIGHT,
    ConstraintReason.IMAGE_BACKLIT ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_BRIGHTNESS)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_BRIGHTNESS)
     }

    /**
     * Prompt when there's not enough light
     */
    ConstraintReason.IMAGE_QUALITY,
    ConstraintReason.IMAGE_DARK ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_DARKNESS)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_DARKNESS)
     }

    /**
     * Prompt when the face is not facing the camera
     */
    ConstraintReason.FACE_DIRECTION ->
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_GAZE)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_GAZE)
     }

    /**
     * Prompt when the face is too close
     */
    ConstraintReason.FACE_NEAR -> {
     constraintMessage = if (isMeasuring) {
      resources.getString(R.string.ERR_CONSTRAINT_POSITION)
     } else {
      resources.getString(R.string.WARNING_CONSTRAINT_TOO_CLOSE)
     }
    }
   }

   if (isMeasuring && (status == ConstraintResult.ConstraintStatus.Error
            || status == ConstraintResult.ConstraintStatus.Warn)
   ) {
    val measurementCancelledMessage = resources.getString(R.string.MEASUREMENT_CANCELED)
    constraintMessage = "$measurementCancelledMessage\n $constraintMessage"
   }

   runOnUiThread {
    if (isNetworkAvailable) {
     measurementView.promptMsg = constraintMessage
    }
   }
  }
  //endregion result and error handling

  //region View Logic
  /**
   * This method sets up and configures the [MeasurementView] class that displays the various UI
   * elements on top of the camera view
   */
  private fun setupMeasurementView() = runOnUiThread {
   measurementView = findViewById(R.id.measurement_view)

   /**
    * Use [MeasurementUIConfiguration] to configure various aspects MeasurementView
    * The default configuration that closely matches the appearance of the standard Anura app
    * from NuraLogix.
    * If you need to use the legacy UI, you can use
    * [MeasurementUIConfiguration.anuraDefaultLegacyUIConfiguration]
    */
   measurementUIConfig = MeasurementUIConfiguration()
   measurementView.setMeasurementUIConfiguration(measurementUIConfig)

   /**
    * Set camera frame dimensions for MeasurementView
    */
   with(measurementView.tracker) {
    setImageDimension(IMAGE_HEIGHT, IMAGE_WIDTH)
    setListener(this@AnuraScannerActivity)
   }
  }

  /**
   * This method sets up the OpenGL [Render] class that displays the camera view
   */
  private fun setupRenderer() {
   /**
    * Typically [VideoFormat] should not be changed. You may adjust [IMAGE_HEIGHT] and
    * [IMAGE_WIDTH] to suit your application and hardware
    */
   videoFormat = VideoFormat(
    VideoFormat.ColorFormat.RGBA,
    30,
    IMAGE_HEIGHT.toInt(),
    IMAGE_WIDTH.toInt()
   )

   /**
    * The [Render] class makes a slight adjustment to the view based on
    * [MeasurementUIConfiguration.MeasurementOutlineStyle]
    */
   val usingOvalUI = measurementUIConfig.measurementOutlineStyle ==
           MeasurementUIConfiguration.MeasurementOutlineStyle.OVAL
   render = Render.createGL20Render(videoFormat, usingOvalUI)
  }

  /**
   * This method sets up the position on the lighting quality star rating based on the screen size
   */
  private fun setupStarPositionsBasedOnScreenSize() = runOnUiThread {
   val screenWidth = Resources.getSystem().displayMetrics.widthPixels
   val screenHeight = Resources.getSystem().displayMetrics.heightPixels
   val xScale = screenWidth.toFloat() / IMAGE_HEIGHT
   val yScale = screenHeight.toFloat() / IMAGE_WIDTH
   val scale = max(xScale, yScale)
   val top = (474 * scale).toInt()
   measurementView.setStarsPosition(30, top, 30, 0)
  }

  /**
   * This method sets up the "3...2...1..." countdown timer when the measurement is about to start
   */
  private fun setupCountdownTimer() {
   measurementStartCountdown = DefaultCountdown(3, object : Countdown.Listener {
    override fun onCountdownTick(value: Int) {
     runOnUiThread {
      measurementView.setCountdown(value.toString())
     }
    }

    override fun onCountdownEnd() {
     startMeasurement()
    }

    override fun onCountdownCancel() {
     runOnUiThread {
      measurementView.setCountdown("")
     }
    }
   })
  }

  /**
   * This method configures the [MeasurementView] class when starting the measurement to show the
   * measurement progress
   */
  private fun setupMeasurementViewForStartMeasurement() = runOnUiThread {
   with(measurementView) {
    with(tracker) {
     showMeasurementProgress(true)
     setMeasurementProgress(0.0f)
    }
    promptMsg = ""
    setCountdown("")
   }
  }

  /**
   * This method displays an error message in the status message area under the measurement outline
   * @param message   The cancellation message to be displayed
   */
  private fun setMeasurementErrorMsg(message: String) = runOnUiThread {
   val measurementCancelledMessage = resources.getString(R.string.MEASUREMENT_CANCELED)
   val errorMsg = "$measurementCancelledMessage\n$message"
   measurementView.promptMsg = errorMsg
   resetMeasurementView()
  }

  /**
   * This method updates the heart rate result inside the heart graphic under the
   * measurement outline
   * @param results   A [MeasurementResults] object containing the results for the current
   *                  measurement
   */
  private fun updateHeartRateResult(results: MeasurementResults) = runOnUiThread {
   if (!results.heartRate.isNaN()) {
    measurementView.setHeartRate(String.format("%.0f", results.heartRate))
   } else {
    measurementView.setHeartRate("--")
   }
  }

  /**
   * This method displays the "Analyzing..." alert dialog that appears while DeepAffex Cloud is
   * processing the measurement after sending data
   */
  private fun displayAnalyzingDialog() = runOnUiThread {
   dismissAnalyzingAlertDialogIfVisible()
   analyzingAlertDialog = AlertDialog.Builder(this)
    .setMessage("Analyzing...")
    .setCancelable(false)
    .create()
   analyzingAlertDialog.show()
  }

  /**
   * This method dismisses the "Analyzing..." alert dialog that appears while DeepAffex Cloud is
   * processing the measurement after sending data
   */
  private fun dismissAnalyzingAlertDialogIfVisible() = runOnUiThread {
   if (this::analyzingAlertDialog.isInitialized && analyzingAlertDialog.isShowing) {
    analyzingAlertDialog.dismiss()
   }
  }

  /**
   * This method responds to [AbstractTrackerView.TrackerViewListener] callback method that occurs
   * when the view size is changed. The face tracker and rendering area need to accommodate
   * the view size change
   */
  override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) = runOnUiThread {
   Log.d(TAG, "onSizeChanged w=$w h=$h")
   val targetBox = ImageUtils.getFaceTargetBox(
    w,
    h,
    IMAGE_HEIGHT.toInt(),
    IMAGE_WIDTH.toInt(),
    measurementUIConfig.measurementOutlineStyle == MeasurementUIConfiguration.MeasurementOutlineStyle.OVAL
   )
   measurementView.tracker.setFaceTargetBox(targetBox)
   faceTracker.setTrackingRegion(w, h, IMAGE_HEIGHT.toInt(), IMAGE_WIDTH.toInt())
   measurementPipeline.setScreenSize(w, h, oldw, oldh)
  }

  //endregion view logic

  //region Activity LifeCycle Methods
  override fun onCreate(savedInstanceState: Bundle?) {
   super.onCreate(savedInstanceState)

   /**
    * Keep the screen on while on the measurement screen
    */
   window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

   /**
    * Setting the layout of the activity
    */
   supportRequestWindowFeature(Window.FEATURE_NO_TITLE)
   setContentView(R.layout.anura_scanner)
   initialize()

   if (checkEmbeddedDeepAffexLicenseAndStudyID()) {
    requestCameraAccessPermission()
    lifecycleScope.launch {
     /**
      * Before launching [AnuraExampleMeasurementActivity], we need to ensure that the
      * application has a valid DeepAffex Cloud access token. The application also needs
      * to ensure it has the latest study configuration binary that's required to
      * initialize DeepAffex Extraction Library
      */
     exampleStartViewModel.verifyDeepAffexTokenAndStudyFile()
    }
   } else {
    /**
     * If either the DeepAffex License Key or Study ID are not configured, show an error
     * dialog box and exit the app
     */
    showExitAppDialog(
     "Sample App Configuration Error",
     "Your DFX_LICENSE_KEY and DFX_STUDY_ID are not set in server.properties"
    )
   }

   /**
    * Initialize and setup Anura Core SDK and associated views
    */
   setupMeasurementView()
   setupMeasurementPipeline()
   setupCustomViews()
  }

 private fun showExitAppDialog(title: String, msg: String) {
  MaterialAlertDialogBuilder(this)
   .setTitle(title)
   .setMessage(msg)
   .setNegativeButton("Exit")
   { _, _ -> exitProcess(0) }
   .setCancelable(false)
   .show()
 }

 private fun checkEmbeddedDeepAffexLicenseAndStudyID(): Boolean {
  return !(BuildConfig.DFX_LICENSE_KEY.isEmpty() || BuildConfig.DFX_STUDY_ID.isEmpty())
 }

 private fun requestCameraAccessPermission() {
  if (ContextCompat.checkSelfPermission(
    this,
    Manifest.permission.CAMERA
   ) == PackageManager.PERMISSION_GRANTED
  ) {
   // Permission already granted
   return
  }
  registerForActivityResult(ActivityResultContracts.RequestPermission()) {
   runOnUiThread {
    Toast.makeText(
     this@AnuraScannerActivity,
     "Camera Permission ${if (it) "Granted" else "Denied"}!",
     Toast.LENGTH_SHORT
    ).show()
   }
  }.run { launch(Manifest.permission.CAMERA) }
 }

 private fun initialize() {
//  setContentView(binding.root)
  SharedPreferencesHelper.initialize(application)
  AnuLogUtil.setShowLog(BuildConfig.DEBUG)

  exampleStartViewModel.readyToMeasure.observe(this) { handleTokenVerified(it) }
  exampleStartViewModel.error.observe(this) { handleError(it) }
 }

 private fun handleTokenVerified(isTokenVerified: Boolean) {
//  binding.goMeasuremntBtn.isEnabled = isTokenVerified
 }

 private fun handleError(errorMsg: String?) {
  Toast.makeText(this, "Error:$errorMsg", Toast.LENGTH_SHORT).show()
 }


 override fun onResume() {
   super.onResume()
   if (this::core.isInitialized) {
    measurementPipeline.setListener(this)
    val status = measurementPipeline.prepare(true)
    if (status != AnuraError.Core.OK) {
     handleMeasurementError(status)
    }
   }
   setupStarPositionsBasedOnScreenSize()
  }

  override fun onPause() {
   super.onPause()
   stopMeasurement()
   if (this::core.isInitialized) {
    measurementPipeline.unprepare()
    resumeScreenBrightness(this)
   }
  }

  override fun onDestroy() {
   Log.d(TAG, "Measurement screen destroyed")
   measurementStartCountdown.stop()
   if (this::core.isInitialized) {
    try {
     measurementPipeline.close()
     faceTracker.close()
    } catch (e: Exception) {
     Log.e(TAG, "Failed on closing MeasurementPipeline: " + e.message)
    }
   }
   dismissAnalyzingAlertDialogIfVisible()
   super.onDestroy()
  }
  //endregion
 }