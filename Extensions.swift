//  Extensions.swift

import Foundation
import UIKit
import AVFoundation
import ReachabilitySwift
import CoreLocation
import CryptoSwift
import Alamofire

let ENCRYPTION_KEY = "#5r*7ytX2@3we1@q"
let ENCYPTION_INITIAL_VECTOR = "$%gf!23s*5yRdVg8"
enum UIUserInterfaceIdiom : Int {
    case unspecified
    
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}
extension Bundle {
    /**
     Loads a plist file from the bundle and returns it's contents as a NSDictionary
     - parameter resourceName: The name of the plist.
     - returns: A NSDictionary representation of the plist.
     */
    public func loadPlist(_ resourceName: String) -> NSDictionary? {
        var plistDict: NSDictionary?
        if let path = path(forResource: resourceName, ofType: "plist") {
            plistDict = NSDictionary(contentsOfFile: path)
        }
        return plistDict
    }
}
extension NSDictionary {
    func toLicenseItems() -> [LicenseItem] {
        var resultArray = [LicenseItem]()
        guard let licensesDicts = self["PreferenceSpecifiers"] as? NSArray as? [NSDictionary] else {
            return resultArray
        }
        for license in licensesDicts {
            guard let title = license["Title"] as? String, let body = license["FooterText"] as? String else {
                continue
            }
            resultArray.append(LicenseItem(title: title, body: body))
        }
        return resultArray
    }
}

extension Float {
    var miles: Float {
        return self * 0.621371
    }
    
    var km: Float {
        return self * 1.60934
    }
    
    var pounds: Float {
        return self * 2.20462
    }
    
    var kg: Float {
        return self * 0.453592
    }
}

extension Double {
    var fitnessVal : Double {
        return ((-0.001 * (self * self)) + (0.66 * self)) - 8.9
    }
}

extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
extension UIViewController {
    func encryptValue(value: String) -> String {
        if let aes = try? AES(key: ENCRYPTION_KEY, iv: ENCYPTION_INITIAL_VECTOR, padding: .pkcs5),
            let aesE = try? aes.encrypt(Array(value.utf8)) {
            //print("AES encrypted: \(String(describing: aesE.toBase64()))")
            //let aesD = try? aes.decrypt(aesE)
            //let decrypted = String(bytes: aesD!, encoding: .utf8)
            //print("AES decrypted: \(decrypted!)")
            return aesE.toBase64()!
        }else  {
            return ""
        }
    }
    func decryptValue (value: String) -> String {
        guard let data = Data(base64Encoded: value) else { return "" }
        if let decrypted = try? AES(key: ENCRYPTION_KEY, iv: ENCYPTION_INITIAL_VECTOR, padding: .pkcs5).decrypt([UInt8](data)) {
            return String(bytes: decrypted, encoding: .utf8) ?? ""
        }else {
            return ""
        }
    }
    
    @objc func getAddressFromLatLon(latitude:Double, longitude:Double, completionMainHandler: @escaping (String) -> ()) {
        
        if getRechabilityStatus() {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = latitude
            center.longitude = longitude
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil) {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    if let pm = placemarks {
                        if pm.count > 0 {
                            let pm = placemarks![0]
                            var addressString : String = ""
                            if pm.locality != nil {
                                addressString = addressString + pm.locality! + ", "
                            }
                            if pm.country != nil {
                                addressString = addressString + pm.country! + ", "
                            }
                            if pm.postalCode != nil {
                                addressString = addressString + pm.postalCode!
                            }
                            completionMainHandler(addressString)
                        }
                    }
            })
        }
    }
    
    func standardDeviation(arr : [Double]) -> Double
    {
        let length = Double(arr.count)
        let avg = arr.reduce(0, +) / length
        let sumOfSquaredAvgDiff = arr.map {pow($0 - avg, 2.0)}.reduce(0, +)
        return sqrt(sumOfSquaredAvgDiff / length)
    }
    
    func cpuUsage() -> Double {
        var kr: kern_return_t
        var task_info_count: mach_msg_type_number_t
        
        task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
        var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))
        
        kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
        if kr != KERN_SUCCESS {
            return -1
        }
        
        var thread_list: thread_act_array_t? = UnsafeMutablePointer(mutating: [thread_act_t]())
        var thread_count: mach_msg_type_number_t = 0
        defer {
            if let thread_list = thread_list {
                vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
            }
        }
        
        kr = task_threads(mach_task_self_, &thread_list, &thread_count)
        
        if kr != KERN_SUCCESS {
            return -1
        }
        
        var tot_cpu: Double = 0
        
        if let thread_list = thread_list {
            
            for j in 0 ..< Int(thread_count) {
                var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
                var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
                kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO),
                                 &thinfo, &thread_info_count)
                if kr != KERN_SUCCESS {
                    return -1
                }
                
                let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)
                
                if threadBasicInfo.flags != TH_FLAGS_IDLE {
                    tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            } // for each thread
        }
        
        return tot_cpu
    }
    
    func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
        var result = thread_basic_info()
        
        result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
        result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
        result.cpu_usage = threadInfo[4]
        result.policy = threadInfo[5]
        result.run_state = threadInfo[6]
        result.flags = threadInfo[7]
        result.suspend_count = threadInfo[8]
        result.sleep_time = threadInfo[9]
        
        return result
    }
    
    func getServiceURL(_ serviceURL : String) -> URL {
        return URL(string: "\(serviceURL)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)!)!
    }
    
    func showAlertView(_ message:String!) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction (title: "OK", style: UIAlertActionStyle.cancel, handler: { action -> Void in
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertView(_ message: String!, completionHandler: @escaping (_ value: Bool) -> Void){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let btnOKAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            completionHandler(true)
        }
        alertController.addAction(btnOKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertView(_ message:String!, defaultTitle:String?, cancelTitle:String?, completionHandler: @escaping (_ value: Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let btnOKAction = UIAlertAction(title: defaultTitle, style: .default) { (action) -> Void in
            completionHandler(true)
        }
        let btnCancelAction = UIAlertAction(title: cancelTitle, style: .default) { (action) -> Void in
            completionHandler(false)
        }
        alertController.addAction(btnOKAction)
        alertController.addAction(btnCancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func LoadDashboardScreen(_ currentVC:UIViewController){
        let vc = currentVC.parent?.parent as! ContainerVC
        vc.initWithObjects()
        isFromDashboard = true
        vc.setContainerVC(navCtr:vc.sessionNav)
        vc.showBottomBar()
        vc.showTopBar()
    }

    func getMonthNumber(_ monthName:String) -> Int{
        
        if monthName == "JAN" || monthName == "JAN." {
            return 01
        }else if monthName == "FEB" || monthName == "FEB." {
            return 02
        }else if monthName == "MAR" || monthName == "MAR." || monthName == "MÄRZ." || monthName == "MÄRZ" || monthName == "MÄR." || monthName == "MÄR" {
            return 03
        }else if monthName == "APR" || monthName == "APR." {
            return 04
        }else if monthName == "MAY" || monthName == "MAY." || monthName == "MAI" || monthName == "MAI"{
            return 05
        }else if monthName == "JUN" || monthName == "JUN." || monthName == "JUNI." || monthName == "JUNI" {
            return 06
        }else if monthName == "JUL" || monthName == "JUL." || monthName == "JULI." || monthName == "JULI" {
            return 07
        }else if monthName == "AUG" || monthName == "AUG." {
            return 08
        }else if monthName == "SEP" || monthName == "SEP." {
            return 09
        }else if monthName == "OCT" || monthName == "OCT." || monthName == "OKT." || monthName == "OKT" {
            return 10
        }else if monthName == "NOV" || monthName == "NOV." {
            return 11
        }else if monthName == "DEC" || monthName == "DEC." || monthName == "DEZ." || monthName == "DEZ" {
            return 12
        }else{
            return 0
        }
    }
    
    func getMonthName(_ monthNumber:Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")!
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM"
        let date = dateFormatter.date(from: "\(monthNumber)")
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date!)
    }
    
    func getDateTimeInString(_ date: Date, _ format:String) -> String{
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func getDateStringFromUTC(_ date: Date, _ format:String) -> String{
        let datefo = DateFormatter()
        datefo.timeZone = TimeZone(abbreviation: "UTC")!
        datefo.locale = Locale(identifier: "en_US_POSIX")
        datefo.dateFormat = format
        return datefo.string(from: date)
    }
    func getDateTime(_ strDate: String, _ format:String) -> Date{
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: strDate)!
    }
    
    //This method will convert second to minutes & hours
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return (hr, min, 60 * secf)
    }
    
    func retrieveTotalDaysInMonth(_ year:Int, _ month: Int) -> Int{
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        return (calendar.range(of: .day, in: .month, for: date)!).count
    }
    
    func getAttributeString(_ str1:String, _ str2:String, _ fontType1:String, _ fontType2:String, _ fontSize1:CGFloat, _ fontSize2:CGFloat, _ foreColor1:UIColor, _ foreColor2:UIColor) -> NSMutableAttributedString{
        let attrString = NSMutableAttributedString()
        let attr1 = NSMutableAttributedString(string: str1, attributes: [NSAttributedStringKey.font: getFont(fontSize1, fontType1), NSAttributedStringKey.foregroundColor : foreColor1])
        let attr2 = NSMutableAttributedString(string: str2, attributes: [NSAttributedStringKey.font: getFont(fontSize2, fontType2), NSAttributedStringKey.foregroundColor : foreColor2])
        attrString.append(attr1)
        attrString.append(attr2)
        return attrString
    }
    
    func getAttributeString(_ str1:String, _ str2:String, _ str3:String, _ fontType1:String, _ fontType2:String, _ fontType3:String, _ fontSize1:CGFloat, _ fontSize2:CGFloat, _ fontSize3:CGFloat, _ foreColor1:UIColor, _ foreColor2:UIColor, _ foreColor3:UIColor) -> NSMutableAttributedString{
        let attrString1 = getAttributeString(str1, str2, fontType1, fontType2, fontSize1, fontSize2, foreColor1, foreColor2)
        let attrString2 = NSMutableAttributedString()
        let attr3 = NSMutableAttributedString(string: str3, attributes: [NSAttributedStringKey.font: getFont(fontSize3, fontType3), NSAttributedStringKey.foregroundColor : foreColor3])
        attrString2.append(attrString1)
        attrString2.append(attr3)
        return attrString2
    }
    
    func getStaticText(_ fontSize:CGFloat) -> NSMutableAttributedString {
        let staticText = NSMutableAttributedString()
        let attr1 = NSMutableAttributedString(string: "\("By_logging_message".localize) ", attributes: [NSAttributedStringKey.font: getFont(fontSize, Fonts.AvenirNextDemiBold), NSAttributedStringKey.foregroundColor : Colors.StaticText])
        let attr2 = NSMutableAttributedString(string: "Terms_Conditions".localize + " ", attributes: [NSAttributedStringKey(rawValue: "terms"):"clickable",NSAttributedStringKey.font: getFont(fontSize, Fonts.AvenirNextDemiBold), NSAttributedStringKey.foregroundColor : Colors.StaticText, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
        let attr3 = NSMutableAttributedString(string: "and".localize + " ", attributes: [NSAttributedStringKey.font: getFont(fontSize, Fonts.AvenirNextDemiBold), NSAttributedStringKey.foregroundColor : Colors.StaticText])
        let attr4 = NSMutableAttributedString(string: "Privacy_policy".localize, attributes: [NSAttributedStringKey(rawValue: "privacy"):"clickable",NSAttributedStringKey.font: getFont(fontSize, Fonts.AvenirNextDemiBold), NSAttributedStringKey.foregroundColor : Colors.StaticText, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.styleSingle.rawValue])
        staticText.append(attr1)
        staticText.append(attr2)
        staticText.append(attr3)
        staticText.append(attr4)
        return staticText
    }
    
    //This method will retrieve geo-cooridnates based on given int value
    func getCoordinate(intValue: Int) -> Float {
        var result: Float!
        let tmp_deg = abs(intValue) / 1000000
        let tmp_min = abs(intValue) - (1000000 * tmp_deg)
        
        result = Float(tmp_deg) + ((Float(tmp_min) / 10000.0) / 60)
        if 0 > intValue {
            result = -result
        }
        return result
    }
    
    //This method will remove text file from document direcotry of device when it is uploaded successfully when session completed stored in server database
    func removeTextFile(_ fileNameToDelete: String){
        
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    //This method will execute given query to the database.
    func executeQuery(_ query:String) {
        if (ConstantDB.kDATABASE?.executeStatements(query))! {
            print("Success")
        }
        else{
            print("Failed")
        }
    }
    
    //This method will convert data into JSON format
    func convertJsonString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //This method will return starting portion of the GPX file
    func getStartPortionOfGPXFile(_ strTime:String) -> String{
        
        print(strTime)
        
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
            "<gpx version=\"1.1\" creator=\"Runtastic: Life is short - live long, http://www.runtastic.com\" " +
            "xsi:schemaLocation=\"http://www.topografix.com/GPX/1/1\n" +
            "   http://www.topografix.com/GPX/1/1/gpx.xsd\n" +
            " http://www.garmin.com/xmlschemas/GpxExtensions/v3\n" +
            "   http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd\n" +
            "   http://www.garmin.com/xmlschemas/TrackPointExtension/v1\n" +
            "   http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd\" " +
            "xmlns=\"http://www.topografix.com/GPX/1/1\" xmlns:gpxtpx=\"http://www.garmin.com/xmlschemas/TrackPointExtension/v1\"" +
            " xmlns:gpxx=\"http://www.garmin.com/xmlschemas/GpxExtensions/v3\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n" +
            "  <metadata>\n" +
            "    <copyright author=\"www.runtastic.com\">\n" +
            "      <year>2019</year>\n" +
            "      <license>http://www.runtastic.com</license>\n" +
            "    </copyright>\n" +
            "    <link href=\"http://www.runtastic.com\">\n" +
            "      <text>runtastic</text>\n" +
            "    </link>\n" +
            "    <time>" + strTime + ".000Z</time>\n" +
            "  </metadata>\n" +
            "  <trk>\n" +
            "    <link href=\"http://www.runtastic.com/sport-sessions/3026318880\">\n" +
            "      <text>Visit this link to view this activity on runtastic.com</text>\n" +
            "    </link>\n" +
        "    <trkseg>\n\t\t\t";
        
    }
    
    //This method will return GPX file data
    func getDataForGPXFile(_ lat:String, _ lng:String, _ time:String, _ HR:String, _ RR:String, _ distance:String, _ speed:String) -> String{
        
        return "<trkpt lon=\"\(lng)\" lat=\"\(lat)\">\n\t\t\t<time>\(time)</time>\n\t\t\t<extensions>\n\t\t\t\t<gpxtpx:TrackPointExtension>\n\t\t\t\t\t<gpxtpx:hr>\(HR)</gpxtpx:hr>\n\t\t\t\t\t<gpxtpx:resp>\(RR)</gpxtpx:resp>\n\t\t\t\t\t<gpxtpx:dist>\(distance)</gpxtpx:dist>\n\t\t\t\t\t<gpxtpx:speed>\(speed)</gpxtpx:speed>\n\t\t\t\t</gpxtpx:TrackPointExtension>\n\t\t\t</extensions>\n\t\t</trkpt>\n\t\t\t";
        
//        return "<trkpt lon=\"\(lng)\" lat=\"\(lat)\">\n<time>\(time)</time>\n<extensions><gpxtpx:TrackPointExtension>\n<gpxtpx:hr>\(HR)</gpxtpx:hr><gpxtpx:resp>\(RR)</gpxtpx:resp>\n<gpxtpx:dist>\(distance)</gpxtpx:dist>\n<gpxtpx:speed>\(speed)</gpxtpx:speed>\n</gpxtpx:TrackPointExtension></extensions>\n</trkpt>";
    }
    
    //This method will return ending portion of the GPX file
    func getEndPortionOfGPXFile() -> String{
        return "\n\t\t</trkseg>\n\t</trk>\n</gpx>"
    }
    
    //This method will retrieve speed value based on given int value
    func getSpeed(intValue: Int) -> Float {
        var result: Float!
        result = Float((intValue * 1852) / 100)
        return (result / 1000)
    }
    
    //Use for calendar
    func getNextMonth(date:Date)->Date {
        return Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    func getPreviousMonth(date:Date)->Date {
        return Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func getMonthName(_ date:Date) -> String {
        let df = DateFormatter()
        if UserModel.sharedInstance().selectedLanguage == "G"{
            df.locale = Locale(identifier: "de-AT")
        }else{
            df.locale = Locale(identifier: "en-US")
        }
        return df.monthSymbols![(Calendar.current.component(.month, from: date)) - 1]
    }
    
    func getYear(_ date:Date) -> String {
        return  "\(Calendar.current.component(.year, from: date))"
    }
    
    //This method is used to speak messages if audio available
    func speakMessage(_ strMessage: String) {
        if let audioAvailable = UserModel.sharedInstance().isAudioAvailable {
            if audioAvailable && !Speaker.shared.synth.isSpeaking {
                let speechUtterance = AVSpeechUtterance(string: strMessage)
                speechUtterance.rate = 0.5
                speechUtterance.volume = 1.0
                if UserModel.sharedInstance().selectedLanguage == "E" {
                    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                }else {
                    speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-AT")
                }
                let objSpeechSynthesizer = AVSpeechSynthesizer()
                objSpeechSynthesizer.speak(speechUtterance)
            }
        }
    }
    
    //Log file create method
    func createLogFile() {
        /*
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let strTemp = dateformatter.string(from: date)
        logFileName = strTemp.replacingOccurrences(of: ":", with: "_") + ".txt"
        UserModel.sharedInstance().logFileName = logFileName
        UserModel.sharedInstance().synchroniseData()
        
        let file = logFileName //this is the file. we will write to and read from it
        let text = String(format: "%@.txt", Date() as CVarArg) //just a text
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print(dir)
            let fileURL = dir.appendingPathComponent(file)
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        }*/
    }
    
    //This method is used to drop tables from databases when user logout from device
    func dropTable(_ tblName:String){
        ConstantDB.kDATABASE?.open()
        do{
            try ConstantDB.kDATABASE?.executeUpdate("DROP TABLE IF EXISTS \(tblName)", values: nil)
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func isIPad() -> Bool{
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }else {
            return false
        }
    }
    
    func getRechabilityStatus() -> Bool {
        let rechability = Reachability.init(hostname: "http://www.google.com")
        if ((rechability?.isReachableViaWiFi)! && (rechability?.isReachable)!) {
            return true
        }else {
            if ((rechability?.isReachableViaWWAN)! && (rechability?.isReachable)!) || ((rechability?.isReachableViaWiFi)! && (rechability?.isReachable)!){
                return true
            }else {
                return false
            }
        }
    }

    func getAllCategoriesText() -> [String]{
        return ["Running".localize,"Walk".localize,"Football_Main".localize,"Ride".localize,"Yoga".localize,"Class".localize,"Sports".localize,"Gym".localize, "Stress Test"]
    }
    
    func getAllCategoriesImage() -> [UIImage] {
        return [UIImage(named: "Running")!, UIImage(named: "Walk")!, UIImage(named: "football")!, UIImage(named: "Ride")!, UIImage(named: "Yoga")!, UIImage(named: "Class")!, UIImage(named: "Sports")!, UIImage(named: "Gym")!, UIImage(named: "Regmen")!]
    }
    
    func getAllSubCategoriesText() -> [[String]] {
        var arrSubCategory = [[String]]()
        arrSubCategory.append(["General".localize, "Adventure_Race".localize, "Brick".localize, "Group".localize, "Race_Event".localize, "Stroller".localize, "Trail".localize, "Treadmill".localize])
        arrSubCategory.append(["General".localize, "Dog_Walk".localize, "Elliptical".localize, "Hike".localize, "Stroller".localize, "Treadmill".localize])
        
        arrSubCategory.append(["FSubCat_Training".localize, "FSubCat_Match".localize, "FSubCat_Regeneration".localize, "FSubCat_Rehabilitation".localize])
        
        arrSubCategory.append(["Racer".localize, "Mountain_Bike".localize, "Touring".localize, "E_Bike".localize, "Indoor".localize, "Smart_Trainer".localize, "Ergometer".localize])
        arrSubCategory.append(["Ashtanga".localize, "Bikram".localize, "Hot".localize, "Power".localize, "Vinyasa".localize])
        arrSubCategory.append(["Aerobics".localize, "Barre".localize, "Combat".localize, "Crossfit".localize, "Spinning".localize, "Pilates".localize, "P90X", "Insanity".localize, "Workout_Video".localize])
        arrSubCategory.append(["Baseball".localize, "Basketball".localize, "Cheerleading".localize, "Hunting".localize, "Fishing".localize, "Golf".localize, "gymnastics".localize, "Hockey".localize, "Kayak".localize, "Locrosse".localize, "Martial Arts".localize, "Rowing".localize, "Skateboarding".localize, "Softball".localize, "Surfing".localize, "Snow_Skiing".localize, "Snow_Boarding".localize, "Tennis".localize, "Volleyball".localize, "Badminton".localize, "Boxing".localize])
        arrSubCategory.append(["Total_Body".localize, "UpperBody".localize, "Legs".localize, "Abs_Core".localize, "Elliptical".localize, "Exersice_Bike".localize, "Jacob_Ladder".localize, "Kettlebell".localize, "Rowing_Machine".localize, "Stair_Machine".localize, "Treadmill".localize, "TRX", "Other_Machine".localize, "Other_Gym".localize])
        arrSubCategory.append(["SubCat_5Min".localize,"SubCat_UTime".localize])
        return arrSubCategory
    }
    
    func getMonthNames() -> [String] {
        return ["JAN","FEB","Mar".localize,"APR","May".localize,"Jun".localize,"Jul".localize,"AUG","SEP","Oct".localize,"NOV","Dec".localize]
    }
    
    func getWeekNames() -> [String] {
        return ["Mon".localize, "Tue".localize, "Wed".localize, "Thu".localize, "Fri".localize, "Sat".localize, "Sun".localize]
    }
    
    func getFont(_ fontSize:CGFloat, _ fontName : String) -> UIFont{
        if isIPad() {
            return UIFont(name: fontName, size: fontSize + 6.0)!
        }else {
            return UIFont(name: fontName, size: fontSize)!
        }
    }
    
    func setButtonColors(_ btn:UIButton, _ backColor:UIColor, _ textColor:UIColor) {
        btn.backgroundColor = backColor
        btn.setTitleColor(textColor, for: .normal)
    }
    
    func getAxisFormatter(prefix: String, decimalSeparator: Bool ,allowFloats: Bool, minIntDigit: Int, minFractionDigit: Int, maxFractionDigit: Int) -> NumberFormatter {
    
        let axisFormatter = NumberFormatter()
        axisFormatter.allowsFloats = allowFloats
        axisFormatter.alwaysShowsDecimalSeparator = decimalSeparator
        axisFormatter.minimumIntegerDigits = minIntDigit
        axisFormatter.minimumFractionDigits = minFractionDigit
        axisFormatter.maximumFractionDigits = maxFractionDigit
        axisFormatter.positiveSuffix = prefix
        return axisFormatter
    }
    
    func getChartFontSize() -> CGFloat{
        if UIScreen.main.bounds.height <= 568.0 {
            return 8.0
        }else {
            return 10.0
        }
    }
    
    func setTintedImage(_ imageViewToTint: UIImageView, _ imageToTint: UIImage) {
        let tintedImage = imageToTint.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageViewToTint.image = tintedImage
        imageViewToTint.tintColor = Colors.settingsON
    }
    
}

extension Data {
    var integer: Int {
        return withUnsafeBytes { $0.pointee }
    }
    var int32: Int32 {
        return withUnsafeBytes { $0.pointee }
    }
    var float: Float {
        return withUnsafeBytes { $0.pointee }
    }
    
    var double: Double {
        return withUnsafeBytes { $0.pointee }
    }
    var string: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    var isValidPassword: Bool {
        let passwordRegex = "[A-Za-z0-9-!@#$%&*ˆ+=_]{6,30}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func ToFile(fileName: String) {
        
        cntLogWrite += 1
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let fileUrl = dir.appendingPathComponent(fileName)
        guard let data = self.data(using: .utf8) else {
            return
        }

        guard FileManager.default.fileExists(atPath: dir.path) else {
            do {
                try data.write(to: fileUrl, options: .atomic)
            } catch {
                print(error)
            }
            return
        }

        if let fileHandle = try? FileHandle(forUpdating: fileUrl) {
            if !data.isEmpty {
                fileHandle.seekToEndOfFile()
                do {
                    try? fileHandle.write(data)
                } catch {
                    print(error)
                }
                
//                if cntLogWrite == 500 {
//                    cntLogWrite = 0
//                    fileHandle.closeFile()
//                }
            }
        }
    }
    
    var keepNumericsOnly: String {
        return self.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
    }
}

extension UIImage {
    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        
        let contextSize: CGSize = contextImage.size
        
        //Set to square
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        
        if to.width > to.height { //Landscape
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height { //Portrait
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else { //Square
            if contextSize.width >= contextSize.height { //Square on landscape (or square)
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        
        let rect: CGRect = CGRect(x : posX, y : posY, width : cropWidth, height : cropHeight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        
        cropped.draw(in: CGRect(x : 0, y : 0, width : to.width, height : to.height))
        
        return cropped
    }
    
    
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

extension Date {
    var startDate: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
    
    var endDate: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func stringFromFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

class LogUploader : NSObject {
    
    var fileName : String?
    var fileType : String?
    
    init(fileName: String, fileType: String) {
        self.fileName = fileName
        self.fileType = fileType
    }
    
    func uploadLogFile(){
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        var fileData = Data()
        let fileUrl = dir.appendingPathComponent(fileName!)
        do {
            fileData = try Data(contentsOf:fileUrl)
        }catch {
            print(error)
        }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(dateFormat.string(from: Date()))
        
        var fw_version = ""
        if UserModel.sharedInstance().ConnectedOBUVersion != nil {
            fw_version = "\(UserModel.sharedInstance().ConnectedOBUVersion!)"
        }
        
        let serviceURL = "\(Constant.web_url)upload_log_new.php"
        let parameters = ["user_id": "\(UserModel.sharedInstance().user_id!)","type":fileType!,"connection_status":"success","datetime":"\(dateFormat.string(from: Date()))","device":"\(UIDevice.current.name) - \(UIDevice.modelName)", "android_version":"\(UIDevice.current.systemVersion)", "app_version":"\(Constant.AppVersion)", "fw_version":fw_version, "from_app":"iPhone"]
        
        print("#Params: \(parameters)")
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if !fileData.isEmpty {
                multipartFormData.append(fileData, withName: "data_file",fileName: self.fileName!, mimeType: "txt")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: serviceURL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if response.response?.statusCode == 200 {
                        print(response.result.value as AnyObject)
                        if let JSONObject = response.result.value as? [String:AnyObject]{
                            if let status = JSONObject["status"] as? String{
                                print(status)
                                if status == "0"{
                                    print("Fail to upload log file")
                                    return
                                }else{
                                    print("Log file uploaded successfully")
                                    self.removeTextFile(self.fileName!)
                                }
                            }
                        }
                    } else {
                        print(response.result.error as AnyObject)
                    }
                }
                break
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }
    
    func removeTextFile(_ fileNameToDelete: String){
        
        var filePath = ""
        
        // Fine documents directory on device
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appendingFormat("/" + fileNameToDelete)
            print("Local path = \(filePath)")
            
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        do {
            let fileManager = FileManager.default
            
            // Check if file exists
            if fileManager.fileExists(atPath: filePath) {
                // Delete file
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
            
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
}

class Speaker : NSObject {
    static let shared = Speaker()
    let synth = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synth.delegate = self
    }

    func speak(_ string: String) {
        let utterance = AVSpeechUtterance(string: string)
        utterance.rate = 0.5
        utterance.volume = 1.0
        if UserModel.sharedInstance().selectedLanguage == "E" {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }else {
            utterance.voice = AVSpeechSynthesisVoice(language: "de-AT")
        }
        synth.speak(utterance)
    }
}

extension Speaker: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("all done")
    }
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
