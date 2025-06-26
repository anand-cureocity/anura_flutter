import Flutter
import UIKit
import class AVFoundation.AVCaptureDevice
import AnuraCore

public class AnuraFlutterPlugin: NSObject, FlutterPlugin {
    var api : DeepAffexMiniAPIClient!
    var measurementDelegate : MeasurementDelegate!
    var user : AnuraUser = .empty
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "anura_flutter_ios", binaryMessenger: registrar.messenger())
    let instance = AnuraFlutterPlugin()
      instance.initializeAPI()
      instance.checkEmbeddedLicense()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
    func checkEmbeddedLicense() {
        if AppConfig.deepaffexLicenseKey.isEmpty || AppConfig.deepaffexStudyID.isEmpty {
            fatalError("You must provide a license key and study ID to use this app")
        }
    }
    
    func initializeAPI() {
        api = DeepAffexMiniAPIClient(network: WebService())
        measurementDelegate = MeasurementDelegate(api: self.api)
    }
    
    func startAnuraMeasurement() {
        // Startup flow does the following:
        //  1- Registers your device with DeepAffex using the embedded license key
        //  2- Validates the device token if a license was already registered
        //  3- Renews the token if it's expired
        //  4- Downloads the latest SDK study configuration associated with the embedded study ID
        
        api.beginStartupFlow { (sdkConfigResult) in
            switch sdkConfigResult {
            case .success(let sdkConfig):
                self.requestCameraPermissionsAndDisplayAnuraViewController(with: sdkConfig)
            case .failure(let error):
                self.startupFlowError(error)
            }
        }
    }
    
    func requestCameraPermissionsAndDisplayAnuraViewController(with sdkConfig: (Data)) {
        // Request Camera Permissions
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.presentAnuraMeasurementViewController(sdkConfig: sdkConfig)
                } else {
                    self.handleCameraPermissionError()
                }
            }
        }
    }
    
    func presentAnuraMeasurementViewController(sdkConfig: Data) {
        
        // Create Measurement Configuration
        //
        // Note: If your application requires the measurement configuration to match
        // the versions prior to 1.9.0, you may use `.defaultLegacyConfiguration`
        
        let measurementConfig = MeasurementConfiguration.defaultConfiguration
        measurementConfig.studyFile = sdkConfig
        
        // Create Measurement UI Configuration
        // Here you can customize various aspects of the Anura Measurement UI
        //
        // You can try out an example customization by replacing `.defaultConfiguration`
        // with the included `.exampleCustomTheme` in this Sample App
        //
        // let uiConfig : MeasurementUIConfiguration = .exampleCustomTheme
        //
        // Note: If your application requires the measurement UI configuration to match
        // the versions prior to 1.9.0, you may use `.defaultLegacyConfiguration`
        
        let uiConfig : MeasurementUIConfiguration = .defaultConfiguration
        
        // Create Face Tracker
        
        // Note: Earlier versions of Anura Core SDK for iOS used visage|SDK FaceTrack
        // As of version 1.9.0 the default face tracker is MediaPipe FaceMesh.
        
        let faceTracker = MediaPipeFaceTracker(quality: .high)
        
        // Create Anura Measurement View Controller
        let viewController = AnuraMeasurementViewController(measurementConfiguration: measurementConfig,
                                                            uiConfiguration: uiConfig,
                                                            faceTracker: faceTracker)
        
        // Set Delegate
        viewController.delegate = measurementDelegate
        
        // Pass the Anura user struct to the measurement delegate
        measurementDelegate.user = user
        
        // Present View Controller
//        present(viewController, animated: true) {
//            self.startMeasurementButton.isEnabled = true
//        }
        
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            rootVC.present(viewController, animated: true) {
//                result(nil) // Success
            }
        } else {
//            result(FlutterError(code: "UNAVAILABLE", message: "No root view controller", details: nil))
        }
    }
    
    
    // MARK: Error Handling
    
    private func startupFlowError(_ error: Error) {
        switch error as? DeepAffexMiniAPIClient.Error {
            
        case .tokenVerificationFailed:
            tokenError()
        case .registerLicenseFailed:
            registerLicenseError()
        case .sdkConfigFailed:
            sdkConfigurationFileError()
        case .none:
            print("There was an error in starting up Anura Core: \(error.localizedDescription)")
        }
    }
    
    private func tokenError() {
        showAlert(title: "Token Error",
                  message: "There was an error in verifying your DeepAffex token. Please check the error log or contact support.")
    }
    
    private func registerLicenseError() {
        showAlert(title: "License Error",
                  message: "There was an error registering your DeepAffex license key. Please check the error log or contact support.")
    }
    
    private func sdkConfigurationFileError() {
        showAlert(title: "SDK Configuration File Error",
                  message: "There was an error retreiving the SDK configuration file. Please check the error log or contact support.")
    }
    
    private func handleCameraPermissionError() {
        showAlert(title: "No Camera Permission",
                  message: "Please grant the app access to the camera before starting a measurement")
    }
    
    private func showAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title,
//                                      message: message,
//                                      preferredStyle: .alert)
//        
//        let okay = UIAlertAction.init(title: "OK",
//                                      style: .default) { [weak self] (_) in
//            self?.dismiss(animated: true,
//                          completion: nil)
//        }
//        alert.addAction(okay)
//        DispatchQueue.main.async {
//            self.present(alert,
//                         animated: true,
//                         completion: nil)
//        }
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method == "launchAnuraScanner"){
          do {
              user = AnuraUser.init(from: call.arguments as! [String : Any])
              startAnuraMeasurement()
          } catch let err {
              // Throw error to Flutter
              result(FlutterError.init(code: "ERROR",
                                       message: err.localizedDescription ,
                                                          details: nil))
            
          }
      }
      else { result(FlutterMethodNotImplemented)
      }
  }
}
