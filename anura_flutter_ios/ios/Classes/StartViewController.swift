//
//  Copyright (c) 2016-2023, Nuralogix Corp.
//  All Rights reserved
//  THIS SOFTWARE IS LICENSED BY AND IS THE CONFIDENTIAL AND
//  PROPRIETARY PROPERTY OF NURALOGIX CORP. IT IS
//  PROTECTED UNDER THE COPYRIGHT LAWS OF THE USA, CANADA
//  AND OTHER FOREIGN COUNTRIES. THIS SOFTWARE OR ANY
//  PART THEREOF, SHALL NOT, WITHOUT THE PRIOR WRITTEN CONSENT
//  OF NURALOGIX CORP, BE USED, COPIED, DISCLOSED,
//  DECOMPILED, DISASSEMBLED, MODIFIED OR OTHERWISE TRANSFERRED
//  EXCEPT IN ACCORDANCE WITH THE TERMS AND CONDITIONS OF A
//  NURALOGIX CORP SOFTWARE LICENSE AGREEMENT.
//

import UIKit
import class AVFoundation.AVCaptureDevice
import AnuraCore

class StartViewController: UIViewController {
    
    @IBOutlet weak var startMeasurementButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var anuraCoreVersionLabel: UITextView!
    
    var api : DeepAffexMiniAPIClient!
    var measurementDelegate : MeasurementDelegate!
    var user : AnuraUser = .empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmbeddedLicense()
        initializeAPI()
        setupKeyboardObservers()
        printAndShowAnuraCoreVersion()
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
        present(viewController, animated: true) {
            self.startMeasurementButton.isEnabled = true
        }
    }
    
    @IBAction func startButtonPressed() {
        startMeasurementButton.isEnabled = false
        startAnuraMeasurement()
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
    
    private func showAlert(title: String, message: String, activateMeasurementButton: Bool = true) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okay = UIAlertAction.init(title: "OK",
                                      style: .default) { [weak self] (_) in
            self?.dismiss(animated: true,
                          completion: nil)
        }
        alert.addAction(okay)
        DispatchQueue.main.async {
            self.present(alert,
                         animated: true,
                         completion: nil)
            self.startMeasurementButton.isEnabled = activateMeasurementButton
        }
    }
    
    private func printAndShowAnuraCoreVersion() {
        let anuraCoreBundle = Bundle(for: AnuraMeasurementViewController.self)
        if let version = anuraCoreBundle.infoDictionary?["CFBundleShortVersionString"],
           let buildNumber = anuraCoreBundle.infoDictionary?["CFBundleVersion"] {
            let versionString = "Anura Core iOS \(version) (Build \(buildNumber))"
            anuraCoreVersionLabel.text = versionString
            print(versionString)
        }
    }
}

// Helper methods to read input from text fields

extension StartViewController {
    
    @IBAction func heightValueChanged(_ textField: UITextField) {
        update(value: \.height, from: textField)
    }
    
    @IBAction func weightValueChanged(_ textField: UITextField) {
        update(value: \.weight, from: textField)
    }
    
    @IBAction func ageValueChanged(_ textField: UITextField) {
        update(value: \.age, from: textField)
    }
    
    @IBAction func genderValueChanged(_ textField: UITextField) {
        update(value: \.gender, from: textField)
    }
    
    @IBAction func partnerIDChanged(_ textField: UITextField) {
        update(value: \.partnerID, from: textField)
    }
    
    private func update(value: WritableKeyPath<AnuraUser, Int>,
                            from textField: UITextField) {
        user[keyPath: value] = Int(textField.text ?? "") ?? -1
    }
    
    private func update(value: WritableKeyPath<AnuraUser, String?>,
                            from textField: UITextField) {
        user[keyPath: value] = textField.text
    }
    
    private func update(value: WritableKeyPath<AnuraUser, AnuraUser.Gender>,
                            from textField: UITextField) {
        user[keyPath: value] = AnuraUser.Gender(rawValue: textField.text?.lowercased() ?? "") ?? AnuraUser.Gender.unknown
    }
}

// Helper methods to observe the keyboard state and adjusting the scroll area

extension StartViewController {
    private func setupKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillBeShown(_ notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillBeHidden(_ notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @IBAction private func viewTapped() {
        endEditing()
    }
    
    private func endEditing() {
        endEditing(view)
    }
    
    private func endEditing(_ subView: UIView) {
        for view in subView.subviews {
            view.resignFirstResponder()
            endEditing(view)
        }
    }
}
