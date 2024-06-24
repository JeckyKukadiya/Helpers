//  Constants.swift


import Foundation
import UIKit
import CoreBluetooth

struct Colors {
    static let Place = UIColor(red: CGFloat(121.0/255.0), green: CGFloat(121.0/255.0), blue: CGFloat(121.0/255.0), alpha: 1.0)

    static let MaxZone = UIColor(red: 238/255, green: 70/255, blue: 70/255, alpha: 1.0)
    static let HardZone = UIColor(red: 248/255, green: 144/255, blue: 21/255, alpha: 1.0)
    static let ModerateZone = UIColor(red: 76/255, green: 183/255, blue: 96/255, alpha: 1.0)
    static let LightZone = UIColor(red: 86/255, green: 149/255, blue: 255/255, alpha: 1.0)
    static let VeryLightZone = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    
    static let BackSelected = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
    static let BackNonSelected = UIColor.init(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
    static let TextNonSelected =  UIColor.init(red: 132/255, green: 132/255, blue: 132/255, alpha: 1.0)
    static let TextSelected =  UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    
    static let settingsON = UIColor(red: 255/255, green: 223/255, blue: 0/255, alpha: 1.0)
    static let settingsOFF = TextSelected
    
    static let BarColor = UIColor.init(red: 255/255, green: 218/255, blue: 0/255, alpha: 1.0)
    static let zoneAutoONColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0)
    
    static let CategorySelectedColor = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1.0)
    
    static let GroupBar1 = UIColor(red: 222/255, green: 195/255, blue: 35/255, alpha: 1.0)
    static let GroupBar2 = UIColor(red: 235/255, green: 219/255, blue: 123/255, alpha: 1.0)
    
    static let lineColor = UIColor(red: 0.0, green: 171/255, blue: 242/255, alpha: 1.0)
    
    static let NonSelectedOBU = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1.0)
    static let BackNonSelected2 = UIColor.init(red: 96/255, green: 96/255, blue: 96/255, alpha: 1.0)
    
    static let BlackColor = UIColor.black
    static let WhiteColor = UIColor.white
    static let ChartLineDefaultColor = UIColor.magenta
    static let ClearColor = UIColor.clear
    
    static let WeatherOdd = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    static let WeatherEven = BackNonSelected
    
    static let StaticText = UIColor(red: 137/255, green: 137/255, blue: 137/255, alpha: 1.0)
    
    static let BlurColor1 = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
    static let BlurColor2 = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1.0)
    
    static let BottomBorderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.16)
}

struct Fonts {
    static let AvenirNextBold = "AvenirNext-Bold"
    static let AvenirNextDemiBold = "AvenirNext-DemiBold"
}

class Constant {
    static var web_url="http://www.telberia.com/projects/qus_app/webservices/"
    //static var web_url="http://qus-dev.com/qus_app/webservices/"
    static var PROJECT_NAME = "QUS Sports" as NSString
    static var defaults = UserDefaults.standard

    static var weatherURL = "https://api.openweathermap.org/data/2.5/"
    static var weatherAppCode = "3e29e62e2ddf6dd3d2ebd28aed069215"
    
    static var GoogleLoginURL = "https://www.googleapis.com/auth/plus.login"
    static var GoogleLoginPlusURL = "https://www.googleapis.com/auth/plus.me"
    static var GoogleClientID = "785078348756-kfhu83t5dt74m7ithflf2fa6uvbvvj6a.apps.googleusercontent.com"
    
    static var TestFairyKey = "SDK-J9uingeF"
    
    static var TwitterConsumerSecretKey = "e29wPCE0grCoHkzlShkO3Q69siQOZCshMtyhfaQskdR8RM8qUl"
    static var TwitterConsumerKey = "O8xD3YwT3iUevnR7Sb87p2jp6"
    
    static var MinBLFWVersion = 1204
    static var AppVersion = "1.41.3"
}

class Characterstics {
    static let RX_SERVICE_UUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    static let RX_CHAR_UUID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    static let HR_SERVICE_UUID = CBUUID(string: "0000180d-0000-1000-8000-00805f9b34fb")
    static let HR_CHAR_UUID = CBUUID(string: "00002a37-0000-1000-8000-00805f9b34fb")
}

class OBUCommands {
    static var arrBattery:[UInt8] = [0x01, 0x00, 0x00, 0x7F]
    
    //.BL commands to send in OBU as per request
    static var arrFileDeleteCMD: [UInt8] = [0x00, 0x00, 0x00, 0x79, 0x02]
    static var arrListFileCMD:[UInt8] = [0x00, 0x00, 0x00, 0x79, 0x01]
    static var arrFileInfoCMD: [UInt8] = [0x00, 0x00, 0x00, 0x79, 0x03]
    static var arrFileDownloadCMD: [UInt8] = [0x00, 0x00, 0x00, 0x79, 0x05]
    static var arrFilestartDownloadCMD: [UInt8] = [0x00, 0x00, 0x00, 0x79, 0x06]
//    static var arrFilestartDownloadCMD: [UInt8] = [0x00, 0x00, 0x00, 0x79, 0x06, 0x00, 0x00, 0x00, 0x00]
    
    //GPS-Modes commands to send in OBU as per request
    static var arrNoGPS:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x08]
    static var arr1Hertz:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x07]
    static var arr10Hertz:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x06]
    
    //OBU start, stop, pause, resume command
    static var arrStart:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x01]
    static var arrStop:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x02]
    static var arrPause:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x03]
    static var arrResume:[UInt8] = [0x01, 0x00, 0x00, 0x7D, 0x04]
}

class OBUData {
    
    static func getAccelerationRate(_ data:Data) -> (Double) {
        
        //Getting x point from OBU. It is found on 4, 5, 6 and 7th bit of 2nd page of OBU
        var xValue = UInt8(data[7]) << 24
        xValue += UInt8(data[6]) << 16
        xValue += UInt8(data[5]) << 8
        xValue += UInt8(data[4])
        let xV = Int(xValue)
        
        //Getting y point from OBU. It is found on 8, 9, 10 and 11th bit of 2nd page of OBU
        var yValue = UInt8(data[11]) << 24
        yValue += UInt8(data[10]) << 16
        yValue += UInt8(data[9]) << 8
        yValue += UInt8(data[8])
        let yV = Int(yValue)
        
        //Getting z point from OBU. It is found on 12, 13, 14 and 15th bit of 2nd page of OBU
        var zValue = UInt8(data[15]) << 24
        zValue += UInt8(data[14]) << 16
        zValue += UInt8(data[13]) << 8
        zValue += UInt8(data[12])
        let zV = Int(zValue)
        
        //Calcualting acceleration rate from x, y and z points. and returning that value when user invoked this method.
        return sqrt(Double(((xV * xV) + (yV * yV) + (zV * zV)) / 100))
    }
    
    //Getting latitude from OBU. It is found on 8, 9, 10 and 11th bit of 24th page of OBU
    static func getLatvalue(_ data:Data) -> (Int) {
        var latValue = Int32(data[11] & 0x000000FF) << 24
        latValue += Int32(data[10] & 0x000000FF) << 16
        latValue += Int32(data[9] & 0x000000FF) << 8
        latValue += Int32(data[8] & 0x000000FF)
        return (Int)(latValue)
//        var latValue = Int(data[11]) << 24
//        latValue += Int(data[10]) << 16
//        latValue += Int(data[9]) << 8
//        latValue += Int(data[8])
//        return latValue
    }
    
    //Getting longitude value from OBU. It is found on 4, 5, 6 and 7th bit of 24th page of OBU
    static func getLongvalue(_ data:Data) -> (Int) {
        var longValue = Int32(data[7] & 0x000000FF) << 24
        longValue += Int32(data[6] & 0x000000FF) << 16
        longValue += Int32(data[5] & 0x000000FF) << 8
        longValue += Int32(data[4] & 0x000000FF)
        return (Int)(longValue)
//        var longValue = Int(data[7]) << 24
//        longValue += Int(data[6]) << 16
//        longValue += Int(data[5]) << 8
//        longValue += Int(data[4])
//        return longValue
    }
    
    //Getting speed from OBU. It is found on 16th and 17th bit of 24th page of OBU
    static func getSpeedValue(_ data:Data) -> (Int) {
        var speedValue = Int32(data[17] & 0x000000FF) << 8 //Int(data[17]) << 8
        speedValue += Int32(data[16] & 0x000000FF) //Int(data[16])
        return (Int)(speedValue)
    }
    
    //Getting satellites from OBU. It is found on 18th bit of 24th page of OBU
    static func getSatellites(_ data:Data) -> (Int) {
        return Int(data[18])
    }
    
    static func getErrorFlag(_ data:Data) -> (Int,Int) {
        return (Int(data[4]), Int(data[5]))
    }
    
    static func getDistance(_ data:Data) -> (Int) {
        var distance = Int(data[19]) << 24
        distance += Int(data[18]) << 16
        distance += Int(data[17]) << 8
        distance += Int(data[16])
        return distance
    }
    
    //Getting start timestamp value from OBU. It is found on 4, 5, 6 and 7th bit of 1st page of OBU
    static func getSessionStartTimestamp(_ data:Data) -> (Int) {
        var tempTimeStamp = Int(data[7]) << 24
        tempTimeStamp += Int(data[6]) << 16
        tempTimeStamp += Int(data[5]) << 8
        tempTimeStamp += Int(data[4])
        return Int(tempTimeStamp)
    }
    
    //Getting file timestamp value from OBU. It is found on 4, 5, 6 and 7th bit of 1st page of OBU
    static func getFileTimestamp(_ data:Data) -> (Int) {
        var tempTimeStamp = Int(data[8]) << 24
        tempTimeStamp += Int(data[7]) << 16
        tempTimeStamp += Int(data[6]) << 8
        tempTimeStamp += Int(data[5])
        return Int(tempTimeStamp)
    }
    //Getting batetry percentage from OBU. It is found on second last bit of 127th page of OBU
    static func getBatteryPercentage(_ data:Data) -> (Int) {
        return Int(data[data.count - 2])
    }
    
    //Getting firmware version to display and also use for firmware update button. It is found on 8, 9, 10 and 11th bits of 127th page of OBU.
    static func getFirmwareVersion(_ data:Data) -> (Int) {
        var versionNo = UInt32(data[11]) << 24
        versionNo += UInt32(data[10]) << 16
        versionNo += UInt32(data[9]) << 8
        versionNo += UInt32(data[8])
        return Int(versionNo)
    }
    
    static func getRRInterval(_ data:Data) -> (Int) {
        var tempRRInterval = Int(data[3]) << 8
        tempRRInterval += Int(data[2])
//        return Int(data[2])
        return tempRRInterval
    }
    
    //Getting heart rate from OBU. It is found on second last bit of OBU data on page number 3.
    static func getHeartRate(_ data:Data) -> (Int) {
        return Int(data[data.count - 2])
    }
    
    //Getting respiration rate from OBU. It is found on last bit of OBU data on page number 3.
    static func getRespirationRate(_ data:Data) -> (Int) {
        return Int(data.last!)
    }
    
    static func getOBUMode(_ data:Data) -> (Int) {
        return Int(data[16])
    }
    
    //MARK:- BL File Sync Method
    //Getting timestamp from data. It can be found on 0, 1, 2 and 3rd bits.
    static func parseTimeStamp(_ data:[UInt8]) -> (Int){
        var tempTimeStamp = UInt32(data[3]) << 24
        tempTimeStamp += UInt32(data[2]) << 16
        tempTimeStamp += UInt32(data[1]) << 8
        tempTimeStamp += UInt32(data[0])
        return Int(tempTimeStamp)
    }
    
    //Getting latitude from data object. It can be found on 4, 5, 6 and 7th bits.
    static func parseLatvalue(_ data:[UInt8]) -> (Int){
        var latValue = Int(data[7]) << 24
        latValue += Int(data[6]) << 16
        latValue += Int(data[5]) << 8
        latValue += Int(data[4])
        return latValue
    }
    
    //Getting longitude from data object. It can be found on 8, 9, 10 and 11th bits.
    static func parseLongvalue(_ data:[UInt8]) -> (Int){
        var longValue = Int(data[11]) << 24
        longValue += Int(data[10]) << 16
        longValue += Int(data[9]) << 8
        longValue += Int(data[8])
        return longValue
    }
    
    //Getting speed value from data object. It can be found on 14th and 15th bit.
    static func parseSpeedvalue(_ data:[UInt8]) -> (Int){
        var speedValue = Int(data[15]) << 8
        speedValue += Int(data[14])
        return speedValue
    }
    
    //Getting satellites from data object. It can be found on 16th bit.
    static func parseSatellite(_ data:[UInt8]) -> (Int){
        return Int(data[16])
    }
    
    //Getting respiration rate from data object. It can be found on 17th bit.
    static func parseRespiration(_ data:[UInt8]) -> (Int){
        return Int(data[17])
    }
    
    //Getting respiration rate from data object. It can be found on 17th bit.
    static func parseHeartRate(_ data:[UInt8]) -> (Int){
        return Int(data[20])
    }
    
    //Getting RR Interval rate from data object. It can be found on 18 & 19th bit.
    static func parseRRInterval(_ data:[UInt8]) -> (Int) {
        var tempRRInterval = Int(data[19]) << 8
        tempRRInterval += Int(data[18])
        return tempRRInterval
    }
    
    //Getting byte data from OBU
    static func getByteDataFromBL(_ data:Data) -> [UInt8]{
        var arrByte = [UInt8]()
        arrByte.append(data[5])
        arrByte.append(data[6])
        arrByte.append(data[7])
        arrByte.append(data[8])
        arrByte.append(data[9])
        arrByte.append(data[10])
        arrByte.append(data[11])
        arrByte.append(data[12])
        arrByte.append(data[13])
        arrByte.append(data[14])
        arrByte.append(data[15])
        arrByte.append(data[16])
        arrByte.append(data[17])
        arrByte.append(data[18])
        arrByte.append(data[19])
        return arrByte
    }
    
    //Getting file information for further data. Based on passed filename from OBU
    static func getFileInfoFromBL(_ data:Data) -> [UInt8]{
        var receivedInfo = [UInt8]()
        receivedInfo.append(UInt8(data[9]))
        receivedInfo.append(UInt8(data[10]))
        receivedInfo.append(UInt8(data[11]))
        receivedInfo.append(UInt8(data[12]))
        return receivedInfo
    }
    
    //Getting file information for datetime. Based on passed filename from OBU
    static func getDateTimeFromInfo(_ data:Data) -> [UInt8] {
        var receivedInfo = [UInt8]()
        receivedInfo.append(UInt8(data[5]))
        receivedInfo.append(UInt8(data[6]))
        receivedInfo.append(UInt8(data[7]))
        receivedInfo.append(UInt8(data[8]))
        return receivedInfo
    }
    
    //Getting size of bl file. Based on passed filename from OBU
    static func getFileSize(_ data:Data) -> (Int) {
        var totalBytes = Int(data[12]) << 24
        totalBytes += Int(data[11]) << 16
        totalBytes += Int(data[10]) << 8
        totalBytes += Int(data[9])
        return totalBytes
    }
    
    //MARK:- 25 bytes payload data
    //Getting timestamp from data. It can be found on 0, 1, 2 and 3rd bits.
    static func parseTimeStamp2(_ data:[UInt8]) -> (Int){
        var tempTimeStamp = UInt32(data[3]) << 24
        tempTimeStamp += UInt32(data[2]) << 16
        tempTimeStamp += UInt32(data[1]) << 8
        tempTimeStamp += UInt32(data[0])
        return Int(tempTimeStamp)
    }
    
    //Getting distance from data. It can be found on 4, 5, 6 and 7th bits.
    static func parseDistance2(_ data:[UInt8]) -> (Int){
        var distance = Int(data[7]) << 24
        distance += Int(data[6]) << 16
        distance += Int(data[5]) << 8
        distance += Int(data[4])
        return distance
    }
    
    //Getting latitude from data object. It can be found on 8, 9, 10 and 11th bits.
    static func parseLatvalue2(_ data:[UInt8]) -> (Int){
        var latValue = Int(data[11]) << 24
        latValue += Int(data[10]) << 16
        latValue += Int(data[9]) << 8
        latValue += Int(data[8])
        return latValue
    }
    
    //Getting longitude from data object. It can be found on 12, 13, 14 and 15th bits.
    static func parseLongvalue2(_ data:[UInt8]) -> (Int){
        var longValue = Int(data[15]) << 24
        longValue += Int(data[14]) << 16
        longValue += Int(data[13]) << 8
        longValue += Int(data[12])
        return longValue
    }
    
    //Getting speed value from data object. It can be found on 18th and 19th bit.
    static func parseSpeedvalue2(_ data:[UInt8]) -> (Int){
        var speedValue = Int(data[19]) << 8
        speedValue += Int(data[18])
        return speedValue
    }
    
    //Getting satellites from data object. It can be found on 20th bit.
    static func parseSatellite2(_ data:[UInt8]) -> (Int){
        return Int(data[20])
    }
    
    //Getting respiration rate from data object. It can be found on 21th bit.
    static func parseRespiration2(_ data:[UInt8]) -> (Int){
        return Int(data[21])
    }
    
    //Getting respiration rate from data object. It can be found on 30, 31, 32 & 33th bit.
    static func parseHeartRate2(_ data:[UInt8]) -> (Int){
        return Int(data[30])
    }
    
    //Getting RR Interval rate from data object. It can be found on 22 to 29th bit.
    static func parseRRInterval2(_ data:[UInt8]) -> (Int) {
        var tempRRInterval = Int(data[23]) << 8
        tempRRInterval += Int(data[22])
        return tempRRInterval
    }
    
    //MARK:- 50 bytes payload data
    //Getting timestamp from data. It can be found on 0, 1, 2 and 3rd bits.
    static func parseTimeStamp3(_ data:[Int32]) -> (Int){
        var tempTimeStamp = UInt32(data[3]) << 24
        tempTimeStamp += UInt32(data[2]) << 16
        tempTimeStamp += UInt32(data[1]) << 8
        tempTimeStamp += UInt32(data[0])
        return Int(tempTimeStamp)
    }
    
    //Getting distance from data. It can be found on 4, 5, 6 and 7th bits.
    static func parseDistance3(_ data:[Int32]) -> (Float){
        var distance = Float((data[7] & 0x000000FF) << 24)
        distance += Float((data[6] & 0x000000FF) << 16)
        distance += Float((data[5] & 0x000000FF) << 8)
        distance += Float(data[4] & 0x000000FF)
        return distance
    }
    
    //Getting latitude from data object. It can be found on 8, 9, 10 and 11th bits.
    static func parseLatvalue3(_ data:[Int32]) -> (Int){
//        var latValue = Int(data[11]) << 24
//        latValue += Int(data[10]) << 16
//        latValue += Int(data[9]) << 8
//        latValue += Int(data[8])
        var latValue = Int32(data[11] & 0x000000FF) << 24
        latValue += Int32(data[10] & 0x000000FF) << 16
        latValue += Int32(data[9] & 0x000000FF) << 8
        latValue += Int32(data[8] & 0x000000FF)
        return (Int)(latValue)
    }
    
    //Getting longitude from data object. It can be found on 12, 13, 14 and 15th bits.
    static func parseLongvalue3(_ data:[Int32]) -> (Int){
//        var longValue = Int(data[15]) << 24
//        longValue += Int(data[14]) << 16
//        longValue += Int(data[13]) << 8
//        longValue += Int(data[12])
        var longValue = Int32(data[15] & 0x000000FF) << 24
        longValue += Int32(data[14] & 0x000000FF) << 16
        longValue += Int32(data[13] & 0x000000FF) << 8
        longValue += Int32(data[12] & 0x000000FF)
        return (Int)(longValue)
    }
    
    //Getting speed value from data object. It can be found on 18th and 19th bit.
    static func parseSpeedvalue3(_ data:[Int32]) -> (Int){
        var speedValue = Int(data[19]) << 8
        speedValue += Int(data[18])
        return speedValue
    }
    
    //Getting satellites from data object. It can be found on 20th bit.
    static func parseSatellite3(_ data:[Int32]) -> (Int){
        return Int(data[20])
    }
    
    //Getting respiration rate from data object. It can be found on 21th bit.
    static func parseRespiration3(_ data:[Int32]) -> (Int){
        return Int(data[21])
    }
    
    //Getting respiration rate from data object. It can be found on 30, 31, 32 & 33th bit.
    static func parseHeartRate3(_ data:[Int32], _ pos:Int) -> (Int){
        return Int(data[pos])
    }
    
    //Getting RR Interval rate from data object. It can be found on 22 to 29th bit.
    static func parseRRInterval3(_ data:[Int32], _ pos1: Int, _ pos2: Int) -> (Int) {
        var tempRRInterval = Int(data[pos2]) << 8
        tempRRInterval += Int(data[pos1])
        return tempRRInterval
    }
    
    static func parseQRSTime(_ data:[Int32], _ pos1: Int, _ pos2: Int, _ pos3: Int, _ pos4: Int) -> Int {
        
        var qrsTime = UInt32(data[pos4]) << 24
        qrsTime += UInt32(data[pos3]) << 16
        qrsTime += UInt32(data[pos2]) << 8
        qrsTime += UInt32(data[pos1])
        
        return Int(qrsTime)
    }
}

class StressTest {
    
    static var userAge = 0
    
    static func getRMSSDTest(_ RMSSD:Double) -> (String, String){

        if UserModel.sharedInstance().dob != nil {
            if let age = UserModel.sharedInstance().dob{
                if age != ""{
                    userAge = Int(age)!
                }else {
                    userAge = 0
                }
            }else {
                userAge = 0
            }
        }else {
            userAge = 0
        }
        
        if userAge > 0 {
            let ageWiseRMSSD = getRMSSDVal()
            let smileVal = (RMSSD * 100) / Double(ageWiseRMSSD)
            let smileImg = getSmiley(smileVal)
            
            return (String(format: "%.2f", smileVal), smileImg)
        }else {
            return ("0.0", "5")
        }
        
    }
    
    static func getRMSSDVal() -> Int{
        if userAge >= 10 && userAge <= 19 {
            return 53
        }else if userAge >= 20 && userAge <= 29 {
            return 43
        }else if userAge >= 30 && userAge <= 39 {
            return 35
        }else if userAge >= 40 && userAge <= 49 {
            return 31
        }else if userAge >= 50 && userAge <= 59 {
            return 25
        }else if userAge >= 60 && userAge <= 69 {
            return 22
        }else if userAge >= 70 && userAge <= 79 {
            return 24
        }else {
            return 21
        }
//        else if userAge >= 80 && userAge <= 99 {
//            return 21
//        }
//        else {
//            return 0
//        }
    }
    
    static func getSmiley(_ value:Double) -> String {

        if (value <= 70) {
            return "5"
        } else if (value > 70 && value <= 80) {
            return "5"
        } else if (value > 80 && value <= 90) {
            return "4"
        } else if (value > 90 && value <= 100) {
            return "3"
        } else if (value > 100 && value <= 110) {
            return "2"
        } else {
            return "1"
        }
        
//        if value < 80.0 {
//            return "1"
//        }else if value >= 80.0 && value < 90.0 {
//            return "2"
//        }else if value >= 90.0 && value < 100.0 {
//            return "3"
//        }else if value >= 100.0 && value < 110.0 {
//            return "4"
//        }else {
//            return "5"
//        }
    }
    
}


class FitnessLevel {
    
    static func getHighFitnessLevel(_ fitnessLevel:Double) -> Double {
        if (fitnessLevel <= 29.8) {
            return 100000
        } else if (fitnessLevel <= 35.0) {
            return 117464
        } else if (fitnessLevel <= 40.0) {
            return 134257
        } else if (fitnessLevel <= 44.8) {
            return 150378
        } else if (fitnessLevel <= 49.4) {
            return 165827
        } else if (fitnessLevel <= 53.8) {
            return 180605
        } else if (fitnessLevel <= 58.0) {
            return 194710
        } else if (fitnessLevel <= 62.0) {
            return 208144
        } else if (fitnessLevel <= 65.8) {
            return 220907
        } else if (fitnessLevel <= 69.4) {
            return 232997
        } else if (fitnessLevel <= 72.8) {
            return 244416
        } else if (fitnessLevel <= 76.0) {
            return 255164
        } else if (fitnessLevel <= 79.0) {
            return 265239
        } else if (fitnessLevel <= 81.8) {
            return 274643
        } else if (fitnessLevel <= 84.4) {
            return 283375
        } else if (fitnessLevel <= 86.8) {
            return 291436
        } else if (fitnessLevel <= 89.0) {
            return 298825
        } else if (fitnessLevel <= 91.0) {
            return 305542
        } else if (fitnessLevel <= 92.8) {
            return 311587
        } else if (fitnessLevel <= 94.4) {
            return 316961
        } else if (fitnessLevel <= 95.8) {
            return 321662
        } else if (fitnessLevel <= 97.0) {
            return 325693
        } else if (fitnessLevel <= 98.0) {
            return 329051
        } else if (fitnessLevel <= 98.8) {
            return 331738
        } else if (fitnessLevel <= 99.4) {
            return 333753
        } else if (fitnessLevel <= 99.8) {
            return 335097
        } else {
            return 335768
        }
    }
}

