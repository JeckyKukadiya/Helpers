
//
//  UserModel.swift
//
//  Created by Jecky Kukadiya on 28/11/16.
//  Copyright © 2016 Jecky Kukadiya. All rights reserved.
//

import UIKit
import CoreBluetooth

class UserModel: NSObject, NSCoding {
    
    var user_id : String?
    var device_id : String?
    var profile_picture : String?
    var name : String?
    var contact_no : String?
    var email : String?
    var password : String?
    var gender : String?
    var weight : String?
    var height : String?
    var dob : String?
    var background_images : String?
    var selectedSessionMode : String?
    var session_images : String?
    var fb_id : String?
    var fb_token : String?
    var insta_id : String?
    var insta_token : String?
    var google_id : String?
    var google_token : String?
    var session_id : String?
    var lastname : String?
    var peripheral : String?
    var isPercentage : Bool?
    var selectedLanguage: String?
    var selectedDistanceUnit: String?
    var selectedWeightUnit: String?
    
    var dashboardImage : UIImage?
    var profileImage : UIImage?
    var sessionImage : UIImage?
    
    var lastConnectedOBUUUID : String?
    var lastConnectedOBUMacID : String?
    
    var isHRPercentage : Bool?
    var isRRPercentage : Bool?
    var isSRPercentage : Bool?
    
    var isHRAutomatic : Bool?
    var isRRAutomatic : Bool?
    var isSRAutomatic : Bool?
    
    var isDiagnostics : Bool?
    
    var hrRate : Int?
    var rrRate : Int?
    var srRate : Int?
    
    var isMobileDataConnected : Bool?
    var isWifiConnected : Bool?
    var isAudioAvailable : Bool?
    var isHeartrateAudioEnable : Bool?
    var isRespirationAudioEnable : Bool?
    var isSpeedAudioEnable : Bool?
    var isKilometerAudioEnable : Bool?
    var isDisconnectSpeak : Bool?
    
    var isIntroVideoPlayed : Bool?
    
    var timeFormat : String?
    
    var isBatteryLow : Bool?
    var batteryPercentage : Int?
    
    var ConnectedOBUVersion : Int?
    var FWVersion : Int?
    var FWFileURL : String?
    var isOBUConnected: Bool?
    
    var GPSMode: String?
    
    var stravaToken : String?
    
    var lastStoredSessionID : Int?
    var lastStoredSessionSubCatID : Int?
    var isSessionStoppedWithoutOBU = 0
    
    //var isBLSynced : Bool?
    
    var t_effect : Double?
    var f_value : Double?
    var lastSessionDate : String?
    
    var BLSessionID : Int?
    var isBLProcessStarted : Bool?
    
    var logFileBleConnection : String?
    var logFileBleSync : String?
    var logFileLiveSession : String?
    var logFileLogin : String?
    var logFileFirmwareUpdate : String?
    
    static var userModel: UserModel?
    static func sharedInstance() -> UserModel {
        if UserModel.userModel == nil {
            if let data = UserDefaults.standard.value(forKey: "UserModel") as? Data {
                let retrievedObject = NSKeyedUnarchiver.unarchiveObject(with: data)
                if let objUserModel = retrievedObject as? UserModel {
                    UserModel.userModel = objUserModel
                    return objUserModel
                }
            }
            
            if UserModel.userModel == nil {
                UserModel.userModel = UserModel.init()
            }
            return UserModel.userModel!
        }
        return UserModel.userModel!
    }
    
    override init() {
        
    }
        
    func synchroniseData(){
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
    
    func removeData() {
        UserModel.userModel = nil
        UserDefaults.standard.removeObject(forKey: "UserModel")
        UserDefaults.standard.synchronize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.user_id = aDecoder.decodeObject(forKey: "user_id") as? String
        self.device_id = aDecoder.decodeObject(forKey: "device_id") as? String
        self.profile_picture = aDecoder.decodeObject(forKey: "profile_picture") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.contact_no = aDecoder.decodeObject(forKey: "contact_no") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.gender = aDecoder.decodeObject(forKey: "gender") as? String
        self.weight = aDecoder.decodeObject(forKey: "weight") as? String
        self.height = aDecoder.decodeObject(forKey: "height") as? String
        self.dob = aDecoder.decodeObject(forKey: "dob") as? String
        self.background_images = aDecoder.decodeObject(forKey: "background_images") as? String
        self.selectedSessionMode = aDecoder.decodeObject(forKey: "selectedSessionMode") as? String
        self.session_images = aDecoder.decodeObject(forKey: "session_images") as? String
        self.fb_id = aDecoder.decodeObject(forKey: "fb_id") as? String
        self.fb_token = aDecoder.decodeObject(forKey: "fb_token") as? String
        self.insta_id = aDecoder.decodeObject(forKey: "insta_id") as? String
        self.insta_token = aDecoder.decodeObject(forKey: "insta_token") as? String
        self.google_id = aDecoder.decodeObject(forKey: "google_id") as? String
        self.google_token = aDecoder.decodeObject(forKey: "google_token") as? String
        self.session_id = aDecoder.decodeObject(forKey: "session_id") as? String
        self.isPercentage = aDecoder.decodeObject(forKey: "isPercentage") as? Bool
        self.lastname = aDecoder.decodeObject(forKey: "lastname") as? String
        self.peripheral = aDecoder.decodeObject(forKey: "peripheral") as? String
        self.selectedLanguage = aDecoder.decodeObject(forKey: "selectedLanguage") as? String
        self.selectedDistanceUnit = aDecoder.decodeObject(forKey: "selectedDistanceUnit") as? String
        self.selectedWeightUnit = aDecoder.decodeObject(forKey: "selectedWeightUnit") as? String
        
        self.dashboardImage = aDecoder.decodeObject(forKey: "dashboardImage") as? UIImage
        self.sessionImage = aDecoder.decodeObject(forKey: "sessionImage") as? UIImage
        self.profileImage = aDecoder.decodeObject(forKey: "profileImage") as? UIImage
        
        self.lastConnectedOBUUUID = aDecoder.decodeObject(forKey: "lastConnectedOBUUUID") as? String
        self.lastConnectedOBUMacID = aDecoder.decodeObject(forKey: "lastConnectedOBUMacID") as? String
        
        self.isHRPercentage = aDecoder.decodeObject(forKey: "isHRPercentage") as? Bool
        self.isRRPercentage = aDecoder.decodeObject(forKey: "isRRPercentage") as? Bool
        self.isSRPercentage = aDecoder.decodeObject(forKey: "isSRPercentage") as? Bool
        
        self.isHRAutomatic = aDecoder.decodeObject(forKey: "isHRAutomatic") as? Bool
        self.isRRAutomatic = aDecoder.decodeObject(forKey: "isRRAutomatic") as? Bool
        self.isSRAutomatic = aDecoder.decodeObject(forKey: "isSRAutomatic") as? Bool
        
        self.isDiagnostics = aDecoder.decodeObject(forKey: "isDiagnostics") as? Bool
        
        self.hrRate = aDecoder.decodeObject(forKey: "hrRate") as? Int
        self.rrRate = aDecoder.decodeObject(forKey: "rrRate") as? Int
        self.srRate = aDecoder.decodeObject(forKey: "srRate") as? Int
        
        self.batteryPercentage = aDecoder.decodeObject(forKey: "batteryPercentage") as? Int
        
        self.isMobileDataConnected = aDecoder.decodeObject(forKey: "isMobileDataConnected") as? Bool
        self.isWifiConnected = aDecoder.decodeObject(forKey: "isWifiConnected") as? Bool
        
        self.isAudioAvailable = aDecoder.decodeObject(forKey: "isAudioAvailable") as? Bool
        self.isHeartrateAudioEnable = aDecoder.decodeObject(forKey: "isHeartrateAudioEnable") as? Bool
        self.isRespirationAudioEnable = aDecoder.decodeObject(forKey: "isRespirationAudioEnable") as? Bool
        self.isSpeedAudioEnable = aDecoder.decodeObject(forKey: "isSpeedAudioEnable") as? Bool
        self.isKilometerAudioEnable = aDecoder.decodeObject(forKey: "isKilometerAudioEnable") as? Bool
        self.isIntroVideoPlayed = aDecoder.decodeObject(forKey: "isIntroVideoPlayed") as? Bool
        
        
        self.isDisconnectSpeak = aDecoder.decodeObject(forKey: "isDisconnectSpeak") as? Bool
        
        self.isBatteryLow = aDecoder.decodeObject(forKey: "isBatteryLow") as? Bool
        
        self.ConnectedOBUVersion = aDecoder.decodeObject(forKey: "ConnectedOBUVersion") as? Int
        self.FWVersion = aDecoder.decodeObject(forKey: "FWVersion") as? Int
        self.FWFileURL = aDecoder.decodeObject(forKey: "FWFileURL") as? String
        
        self.GPSMode = aDecoder.decodeObject(forKey: "GPSMode") as? String
        
        self.stravaToken = aDecoder.decodeObject(forKey: "stravaToken") as? String
        
        self.lastStoredSessionID = aDecoder.decodeObject(forKey: "lastStoredSessionID") as? Int
        self.lastStoredSessionSubCatID = aDecoder.decodeObject(forKey: "lastStoredSessionSubCatID") as? Int
        self.isSessionStoppedWithoutOBU = aDecoder.decodeObject(forKey: "isSessionStoppedWithoutOBU") as? Int ?? 0
        
        //self.isBLSynced = aDecoder.decodeObject(forKey: "isBLSynced") as? Bool
        
        self.t_effect = aDecoder.decodeObject(forKey: "t_effect") as? Double
        self.f_value = aDecoder.decodeObject(forKey: "f_value") as? Double
        self.lastSessionDate = aDecoder.decodeObject(forKey: "lastSessionDate") as? String
        self.timeFormat = aDecoder.decodeObject(forKey: "timeFormat") as? String
        
        self.BLSessionID = aDecoder.decodeObject(forKey: "BLSessionID") as? Int
        self.isBLProcessStarted = aDecoder.decodeObject(forKey: "isBLProcessStarted") as? Bool
        
        self.logFileBleConnection = aDecoder.decodeObject(forKey: "logFileBleConnection") as? String
        self.logFileBleSync = aDecoder.decodeObject(forKey: "logFileBleSync") as? String
        self.logFileLiveSession = aDecoder.decodeObject(forKey: "logFileLiveSession") as? String
        self.logFileLogin = aDecoder.decodeObject(forKey: "logFileLogin") as? String
        self.logFileFirmwareUpdate = aDecoder.decodeObject(forKey: "logFileFirmwareUpdate") as? String
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.user_id, forKey: "user_id")
        aCoder.encode(self.device_id, forKey: "device_id")
        aCoder.encode(self.profile_picture, forKey: "profile_picture")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.contact_no, forKey: "contact_no")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.gender, forKey: "gender")
        aCoder.encode(self.weight, forKey: "weight")
        aCoder.encode(self.height, forKey: "height")
        aCoder.encode(self.dob, forKey: "dob")
        aCoder.encode(self.background_images, forKey: "background_images")
        aCoder.encode(self.selectedSessionMode, forKey: "selectedSessionMode")
        aCoder.encode(self.session_images, forKey: "session_images")
        aCoder.encode(self.fb_id, forKey: "fb_id")
        aCoder.encode(self.fb_token, forKey: "fb_token")
        aCoder.encode(self.insta_id, forKey: "insta_id")
        aCoder.encode(self.insta_token, forKey: "insta_token")
        aCoder.encode(self.google_id, forKey: "google_id")
        aCoder.encode(self.google_token, forKey: "google_token")
        aCoder.encode(self.session_id, forKey: "session_id")
        aCoder.encode(self.isPercentage, forKey: "isPercentage")
        aCoder.encode(self.lastname, forKey: "lastname")
        aCoder.encode(self.peripheral, forKey: "peripheral")
        aCoder.encode(self.selectedLanguage, forKey: "selectedLanguage")
        aCoder.encode(self.selectedDistanceUnit, forKey: "selectedDistanceUnit")
        aCoder.encode(self.selectedWeightUnit, forKey: "selectedWeightUnit")
        
        aCoder.encode(self.dashboardImage, forKey: "dashboardImage")
        aCoder.encode(self.sessionImage, forKey: "sessionImage")
        aCoder.encode(self.profileImage, forKey: "profileImage")
        
        aCoder.encode(self.lastConnectedOBUUUID, forKey: "lastConnectedOBUUUID")
        aCoder.encode(self.lastConnectedOBUMacID, forKey: "lastConnectedOBUMacID")

        aCoder.encode(self.isHRPercentage, forKey: "isHRPercentage")
        aCoder.encode(self.isRRPercentage, forKey: "isRRPercentage")
        aCoder.encode(self.isSRPercentage, forKey: "isSRPercentage")
        
        aCoder.encode(self.isHRAutomatic, forKey: "isHRAutomatic")
        aCoder.encode(self.isRRAutomatic, forKey: "isRRAutomatic")
        aCoder.encode(self.isSRAutomatic, forKey: "isSRAutomatic")
        
        aCoder.encode(self.isDiagnostics, forKey: "isDiagnostics")
        
        aCoder.encode(self.hrRate, forKey: "hrRate")
        aCoder.encode(self.rrRate, forKey: "rrRate")
        aCoder.encode(self.srRate, forKey: "srRate")
        
        aCoder.encode(self.batteryPercentage, forKey: "batteryPercentage")
        
        aCoder.encode(self.isMobileDataConnected, forKey: "isMobileDataConnected")
        aCoder.encode(self.isWifiConnected, forKey: "isWifiConnected")
        
        aCoder.encode(self.isAudioAvailable, forKey: "isAudioAvailable")
        aCoder.encode(self.isHeartrateAudioEnable, forKey: "isHeartrateAudioEnable")
        aCoder.encode(self.isRespirationAudioEnable, forKey: "isRespirationAudioEnable")
        aCoder.encode(self.isSpeedAudioEnable, forKey: "isSpeedAudioEnable")
        aCoder.encode(self.isKilometerAudioEnable, forKey: "isKilometerAudioEnable")
        aCoder.encode(self.isIntroVideoPlayed, forKey: "isIntroVideoPlayed")
        
        aCoder.encode(self.isDisconnectSpeak, forKey: "isDisconnectSpeak")
        
        aCoder.encode(self.isBatteryLow, forKey: "isBatteryLow")
        
        aCoder.encode(self.ConnectedOBUVersion, forKey: "ConnectedOBUVersion")
        aCoder.encode(self.FWVersion, forKey: "FWVersion")
        aCoder.encode(self.FWFileURL, forKey: "FWFileURL")
        
        aCoder.encode(self.isOBUConnected, forKey: "isOBUConnected")
        aCoder.encode(self.GPSMode, forKey: "GPSMode")
        
        aCoder.encode(self.stravaToken, forKey: "stravaToken")

        aCoder.encode(self.lastStoredSessionID, forKey: "lastStoredSessionID")
        aCoder.encode(self.lastStoredSessionSubCatID, forKey: "lastStoredSessionSubCatID")
        aCoder.encode(self.isSessionStoppedWithoutOBU, forKey: "isSessionStoppedWithoutOBU")
        
        //aCoder.encode(self.isBLSynced, forKey: "isBLSynced")
        
        aCoder.encode(self.t_effect, forKey: "t_effect")
        aCoder.encode(self.f_value, forKey: "f_value")
        aCoder.encode(self.lastSessionDate, forKey: "lastSessionDate")
        aCoder.encode(self.timeFormat, forKey: "timeFormat")
        
        aCoder.encode(self.BLSessionID, forKey: "BLSessionID")
        aCoder.encode(self.isBLProcessStarted, forKey: "isBLProcessStarted")
        
        aCoder.encode(self.logFileBleConnection, forKey: "logFileBleConnection")
        aCoder.encode(self.logFileBleSync, forKey: "logFileBleSync")
        aCoder.encode(self.logFileLiveSession, forKey: "logFileLiveSession")
        aCoder.encode(self.logFileLogin, forKey: "logFileLogin")
        aCoder.encode(self.logFileFirmwareUpdate, forKey: "logFileFirmwareUpdate")
    }
}
