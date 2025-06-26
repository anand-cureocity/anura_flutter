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

import Foundation

enum AppConfig {
    
    // Your DeepAffex license key and study ID can be obtained
    // by your administrator from DeepAffex Dashboard:
    // https://dashboard.deepaffex.ai
    
    // Must provide a DeepAffex license key for the app to work
    static let deepaffexLicenseKey = "102b5186-5f4f-4a81-ad7f-2e0daa7ae3f1"
    
    // Must provide a study ID to send measurement data
    static let deepaffexStudyID = "836fa304-700d-421c-9a75-c5470cff6086"
    
    // DeepAffex API Hostname
    // International: api.deepaffex.ai
    // China: api.deepaffex.cn
    static let deepaffexAPIHostname = "api.deepaffex.ai"
}
