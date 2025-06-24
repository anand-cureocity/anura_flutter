package com.example.verygoodcore

import ai.nuralogix.anurasdk.core.entity.MeasurementQuestionnaire
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Intent
import com.example.verygoodcore.anura.AnuraScannerActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import android.os.Bundle
import android.util.Log

class AnuraFlutterPlugin : FlutterPlugin, MethodCallHandler,ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

     var measurementQuestionnaire = MeasurementQuestionnaire()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "anura_flutter_android")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "launchAnuraScanner") {
            activity?.let {
                val intent = Intent(it, AnuraScannerActivity::class.java)
                val user = call.arguments as? Map<String, Any>
                Log.d("FLutter Plugin",user.toString())
                val bundle = Bundle()
                user?.forEach { (key, value) ->
                    when (value) {
                        is String -> bundle.putString(key, value)
                        is Int -> bundle.putInt(key, value)
                        is Double -> bundle.putDouble(key, value)
                        is Float -> bundle.putFloat(key, value)
                        is Boolean -> bundle.putBoolean(key, value)
                    }
                }
                intent.putExtras(bundle)
                it.startActivity(intent)
                Log.d("FLutter Plugin","bundle=$bundle")
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            } ?: run {
                result.error("NO_ACTIVITY", "Activity is null", null)
            }
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    // ActivityAware methods
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}