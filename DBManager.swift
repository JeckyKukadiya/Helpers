//  DBManager.swift

import UIKit
import FMDB

struct ConstantDB {
    struct Path {
        static let Documents = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        static let kDB_NAME = "Peripherals.sqlite"
        static let kSHARED_INSTANCE = DBManager.sharedDbManager()
    }
    
    static let kDB_PATH = Path.Documents.appending("/\(Path.kDB_NAME)")
    static let kDATABASE = Path.kSHARED_INSTANCE.database
    
    struct HRZone_Table{
        static let min1 = "min1"
        static let min2 = "min2"
        static let min3 = "min3"
        static let min4 = "min4"
        static let min5 = "min5"
        static let max1 = "max1"
        static let max2 = "max2"
        static let max3 = "max3"
        static let max4 = "max4"
        static let max5 = "max5"
        static let isDefault = "isDefault"
    }
    
    struct RRZone_Table{
        static let min1 = "min1"
        static let min2 = "min2"
        static let min3 = "min3"
        static let min4 = "min4"
        static let min5 = "min5"
        static let max1 = "max1"
        static let max2 = "max2"
        static let max3 = "max3"
        static let max4 = "max4"
        static let max5 = "max5"
        static let isDefault = "isDefault"
    }
    
    struct SRZone_Table{
        static let min1 = "min1"
        static let min2 = "min2"
        static let min3 = "min3"
        static let min4 = "min4"
        static let min5 = "min5"
        static let max1 = "max1"
        static let max2 = "max2"
        static let max3 = "max3"
        static let max4 = "max4"
        static let max5 = "max5"
        static let isDefault = "isDefault"
    }
    
    struct DataReceived_table{
        static let heart_rate = "heart_rate"
        static let respiration_rate = "respiration_rate"
        static let acceleration = "acceleration"
        static let speed = "speed"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let address = "address"
        static let isUpload = "isUpload"
        static let date = "date"
        static let server_session_id = "server_session_id"
        static let session_id = "session_id"
        static let session_time = "session_time"
        static let distance = "distance"
        static let month = "month"
        static let year = "year"
        static let caleri_burn = "caleri_burn"
        static let RR_Interval = "RR_Interval"
    }

    struct UserDetail_Table{
        static let user_id = "user_id"
        static let user_name = "user_name"
        static let email = "email"
        static let gender = "gender"
        static let weight = "weight"
        static let height = "height"
        static let dob = "dob"
        static let profile_image = "profile_image"
        static let contact_no = "contact_no"
        static let bg_image = "bg_image"
        static let password = "password"
        static let session_image = "session_image"
    }
    
    struct Session_Table{
        static let session_id = "session_id"
        static let category = "category"
        static let sub_category = "sub_category"
        static let session_time = "session_time"
        static let start_time = "start_time"
        static let end_time = "end_time"
        static let av_hr = "av_hr"
        static let av_rr = "av_rr"
        static let av_speed = "av_speed"
        static let distance = "distance"
        static let duration = "duration"
        static let caleri_burn = "caleri_burn"
        static let server_session_id = "server_session_id"
        static let date_time = "date_time"
    }
    
    struct RenameOBU {
        static let uuid = "uuid"
        static let renamedName = "renamedName"
    }
    
    struct RegmenDataTable {
        static let regmen_id = "regmen_id"
        static let session_id = "session_id"
        static let SDNN = "SDNN"
        static let RMSSD = "RMSSD"
        static let pNN50 = "pNN50"
        static let LF_HF_Ratio = "LF_HF_Ratio"
        static let sd1_sd2_ratio = "sd1_sd2_ratio"
        static let isUpload = "isUpload"
    }
    
    struct SessionImageNoteTable1 {
        static let image_note_id = "image_note_id"
        static let session_id = "session_id"
        static let notice = "notice"
        static let imagelink = "imagelink"
        static let imageid = "imageid"
    }
    
    struct TrainingFitnessTable {
        static let trainingId = "trainingId"
        static let session_id = "session_id"
        static let trainingEffect = "trainingEffect"
        static let fitnessLevel = "fitnessLevel"
        static let isUpload = "isUpload"
    }
    
    struct SessionCustomTitleTable {
        static let titleId = "titleId"
        static let session_id = "session_id"
        static let custom_title = "custom_title"
        static let isUpload = "isUpload"
    }
    
}

class DBManager: NSObject {
    var database: FMDatabase!
    var databaseQueue: FMDatabaseQueue!
    
    class func sharedDbManager() -> DBManager {
        var sharedDbManager: DBManager?
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if sharedDbManager == nil {
                sharedDbManager = DBManager()
            }
        }
        return sharedDbManager!
    }
    
    override init() {
        super.init()
        
        if !(database != nil) {
            database = FMDatabase(path: ConstantDB.kDB_PATH)
            databaseQueue = FMDatabaseQueue(path: ConstantDB.kDB_PATH)
        }
        
        copyDatabaseToPath()
        openDb()
    }
    
    func copyDatabaseToPath() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: ConstantDB.kDB_PATH) {
            let fromPath: String = URL(fileURLWithPath: (Bundle.main.resourcePath)!).appendingPathComponent(ConstantDB.Path.kDB_NAME).absoluteString
            try? fileManager.copyItem(atPath: fromPath, toPath: ConstantDB.kDB_PATH)
        }
    }
    
    func openDb() {
        
        if !database.open() {
            print("Could not open db.")
        }
    }
}
