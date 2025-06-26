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

struct AnuraUser {
    
    enum Gender: String {
           case female
           case male
           case unknown
           
           // Proper string initialization
           init(from string: String?) {
               guard let string = string?.lowercased() else {
                   self = .unknown
                   return
               }
               self = Gender(rawValue: string) ?? .unknown
           }
       }
       
       var partnerID: String?
       var height: Int
       var weight: Int
       var age: Int
       var gender: Gender
       
       // MARK: - Initializers
       
       // Custom initializer from dictionary
       init?(from dictionary: [String: Any]?) {
           guard let dict = dictionary else { return nil }
           
           self.age = dict["age"] as? Int ?? -1
           self.height = dict["height"] as? Int ?? -1
           self.weight = dict["weight"] as? Int ?? -1
           self.gender = Gender(from: dict["sex"] as? String)
           self.partnerID = dict["partnerID"] as? String
       }
       
       // Explicit memberwise initializer
       init(partnerID: String?, height: Int, weight: Int, age: Int, gender: Gender) {
           self.partnerID = partnerID
           self.height = height
           self.weight = weight
           self.age = age
           self.gender = gender
       }
       
       // Empty static instance
       static var empty: AnuraUser {
           return AnuraUser(
               partnerID: nil,
               height: -1,
               weight: -1,
               age: -1,
               gender: .unknown
           )
       }
    var isValid : Bool {
        return hasValidAge && hasValidHeightAndWeight && hasKnownGender
    }
    
    var measurementProperties : [String: String] {
        guard isValid else {
            return [:]
        }
        
        return ["height": String(height),
                "weight": String(weight),
                "age": String(age),
                "gender": gender.rawValue]
    }
    
    var bmi : Double {
        let heightInMeters = Double(height) / 100
        let bmi = (Double(weight) / Double(heightInMeters * heightInMeters)).rounded()
        return bmi
    }
    
    var hasValidAge : Bool {
        return (13 ... 120).contains(age)
    }
    
    var hasValidHeightAndWeight : Bool {
         return (9 ... 66).contains(bmi) &&
                (120 ... 220).contains(height) &&
                (30 ... 300).contains(weight)
    }
    
    var hasKnownGender : Bool {
        return gender != .unknown
    }
    

}
