
//
//  FirebaseManager.swift

import Foundation
import AppKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import FirebaseStorage

class FirebaseManager: NSObject {
    
    let MAIN_URL = "https://codemenschen-app.firebaseio.com"
    let STORAGE_URL = "gs://codemenschen-app.appspot.com"
    let STORAGE_IMAGE = "Images/"
    let STORAGE_DOCUMENTS = "Documents/"
    let STORAGE_AUDIOS = "Audios/"
    let STORAGE_VIDEOS = "Videos/"
    let CHATS = "/messages/" // Main Directory
    let USER_USERS_REF = "/users/"  // Main Directory
    let USER_DEVELOPERS_REF = "/developers/"  // Main Directory
    let LAST_ACTIONS = "/last_actions/" // Main Directory
    let USER_DIRECTORY_FOR_GROUP: String = "/participants/" // Sub Directory
    let LAST_MESSAGE_COUNTS: String = "/MessageCounts/"
    let kCurrentDateTimestamp = [".sv": "timestamp"]
    
    
    var mainRef: DatabaseReference = DatabaseReference()
    var storageRef: StorageReference = StorageReference()
    var percentage = Double()
    
    //MARK:- Shared Instance
    class var sharedInstance: FirebaseManager {
        struct Static {
            static let instance: FirebaseManager = FirebaseManager()
        }
        Static.instance.setUp()
        return Static.instance
    }
    
    func setUp() {
        mainRef = Database.database().reference()
        storageRef = Storage.storage().reference()
    }
    
    //MARK:- Channel Creation & Deletion
    func createChannel(taskID: String, projectID: String) {
        let channelID = "\(projectID)_\(taskID)"
        let strURL: String = String(format: "%@%@/%@", mainRef, CHATS, channelID)
        let NewChannelDirectory = Database.database().reference(fromURL: strURL)
        
        let checkURL: String = String(format: "%@%@", mainRef, CHATS)
        let checkDirectory = Database.database().reference(fromURL: checkURL)
        
        checkDirectory.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if !snapshot.exists() {
                NewChannelDirectory.setValue("Single Chat")
            }else {
                let arrKeys = (snapshot.value as! [String: AnyObject]).keys
                if !arrKeys.contains(channelID) {
                    NewChannelDirectory.setValue("Single")
                }
            }
        }
    }
    
    func createUserChannel(_ channelID: String) {
        
        let strURL: String = String(format: "%@%@/%@", mainRef, CHATS, channelID)
        let NewChannelDirectory = Database.database().reference(fromURL: strURL)
        
        let checkURL: String = String(format: "%@%@", mainRef, CHATS)
        let checkDirectory = Database.database().reference(fromURL: checkURL)
        
        checkDirectory.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if !snapshot.exists() {
                NewChannelDirectory.setValue("Personal Chat")
            }else {
                let arrKeys = (snapshot.value as! [String: AnyObject]).keys
                if !arrKeys.contains(channelID) {
                    NewChannelDirectory.setValue("Personal Chat")
                }
            }
        }
    }
    
    func deleteTaskChannel(_ channelId: String) {
        
        let strURL = String(format: "%@%@", mainRef, CHATS)
        let messagePath = Database.database().reference(fromURL: strURL)

        messagePath.child(channelId).removeValue { (error, ref) in
            if error != nil {
                print("fail to delete")
                return
            }
        }

        let MstrURL = String(format: "%@%@", mainRef, LAST_MESSAGE_COUNTS)
        let MmessagePath = Database.database().reference(fromURL: MstrURL)

        MmessagePath.child(channelId).removeValue { (error, ref) in
            if error != nil {
                print("fail to delete")
                return
            }
        }

        let arr = channelId.split(separator: "_")
        
        let strActionURL = String(format: "%@%@", mainRef, LAST_ACTIONS)
        
        let messageActionsPath = Database.database().reference(fromURL: strActionURL)
        messageActionsPath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            if counts > 0 {
                messageActionsPath.queryLimited(toLast: UInt(counts)).observeSingleEvent(of: .value, with: { (snapShot) in
                    if let dict = snapShot.value as? [String: AnyObject] {
                        if dict.keys.count > 0 {
                            for key: String in Array(dict.keys) {
                                let dictionary = dict[key]! as! [String : AnyObject]
//                                print(dictionary)
                                if let taskID = dictionary["taskId"] as? String {
                                    if taskID == arr[1] {
                                        let strActionSubURL = String(format: "%@%@%@", self.mainRef, self.LAST_ACTIONS, key)
                                        let messageActionsSubPath = Database.database().reference(fromURL: strActionSubURL)
                                        messageActionsSubPath.removeValue(completionBlock: { (error, ref) in
                                            if error != nil {
                                                print("fail to delete")
                                                return
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                })
            }
        })
    }
    
    func deleteProjectChannel(_ channelId: String) {
        
        let strURL = String(format: "%@%@", mainRef, CHATS)
        let messagePath = Database.database().reference(fromURL: strURL)
        
        messagePath.child(channelId).removeValue { (error, ref) in
            if error != nil {
                print("fail to delete")
                return
            }
        }
        
        let MstrURL = String(format: "%@%@", mainRef, LAST_MESSAGE_COUNTS)
        let MmessagePath = Database.database().reference(fromURL: MstrURL)
        MmessagePath.child(channelId).removeValue { (error, ref) in
            if error != nil {
                print("fail to delete")
                return
            }
        }
        
        let strActionURL = String(format: "%@%@", mainRef, LAST_ACTIONS)
        
        let messageActionsPath = Database.database().reference(fromURL: strActionURL)
        messageActionsPath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            if counts > 0 {
                messageActionsPath.queryLimited(toLast: UInt(counts)).observeSingleEvent(of: .value, with: { (snapShot) in
                    if let dict = snapShot.value as? [String: AnyObject] {
                        if dict.keys.count > 0 {
                            for key: String in Array(dict.keys) {
                                let dictionary = dict[key]! as! [String : AnyObject]
//                                print(dictionary)
                                if let projectId = dictionary["projectId"] as? String {
                                    if projectId == channelId {
                                        let strActionSubURL = String(format: "%@%@%@", self.mainRef, self.LAST_ACTIONS, key)
                                        let messageActionsSubPath = Database.database().reference(fromURL: strActionSubURL)
                                        messageActionsSubPath.removeValue(completionBlock: { (error, ref) in
                                            if error != nil {
                                                print("fail to delete")
                                                return
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                })
            }
        })
        
    }
    
    
    //MARK:- User and FCM Management
    func setUserOnOffStatus(status: String) {
        let strURL = String(format: "%@%@%@", mainRef, USER_USERS_REF, UserModel.sharedInstance().user_id!)
        let userPath = Database.database().reference(fromURL: strURL)
        var dictUser = [String: String]()
        dictUser["user_id"] = UserModel.sharedInstance().user_id
        dictUser["name"] = UserModel.sharedInstance().fullName
        dictUser["isOnline"] = status
        dictUser["userProfile"] = UserModel.sharedInstance().profile_picture
        userPath.updateChildValues(dictUser)
    }
    
    func isUserOnline(userId: String, completionHandler: @escaping (_ isOnline: String) -> Void) {
//        let strURL = String(format: "%@%@%@", mainRef, USER_USERS_REF, userId)
//        let userPath = Database.database().reference(fromURL: strURL)
//        userPath.queryLimited(toLast: 1).observe(.childChanged, with:  { (snapshot) in
//            var messages = [AnyObject]()
//            messages.append(snapshot.value! as AnyObject)
//            print(snapshot.value as Any)
//            let userDict = snapshot.value as! [String : AnyObject]
//            if userDict["isOnline"] as! String == "yes" {
//                completionHandler("yes")
//            } else {
//                completionHandler("no")
//            }
//        })
        let strURL = String(format: "%@%@%@", mainRef, USER_USERS_REF, userId)
        let userPath = Database.database().reference(fromURL: strURL)
        userPath.queryOrderedByValue().observe(.value, with:  { (snapshot) in
            var messages = [AnyObject]()
            messages.append(snapshot.value! as AnyObject)
//            print(snapshot.value as Any)
            
            if snapshot.exists() {
                let userDict = snapshot.value as! [String : AnyObject]
                if userDict["isOnline"] as! String == "yes" {
                    completionHandler("yes")
                } else {
                    completionHandler("no")
                }
            }else {
                completionHandler("no")
            }
        })
    }
    
    func isDeveloperOnline(userId: String, completionHandler: @escaping (_ isOnline: String) -> Void) {
        let strURL = String(format: "%@%@%@", mainRef, USER_DEVELOPERS_REF, userId)
        let userPath = Database.database().reference(fromURL: strURL)
        userPath.queryOrderedByValue().observe(.value, with:  { (snapshot) in
            var messages = [AnyObject]()
            messages.append(snapshot.value! as AnyObject)
//            print(snapshot.value as Any)
            
            if snapshot.exists() {
                let userDict = snapshot.value as! [String : AnyObject]
                if userDict["status"] as! String == "online" {
                    completionHandler("yes")
                } else {
                    completionHandler("no")
                }
            }else {
                completionHandler("no")
            }
        })
    }
    
    func getProfilePicture(userId: String, completionHandler: @escaping (_ photo: String , _ name : String) -> Void) {
        let strURL = String(format: "%@%@%@", mainRef, USER_USERS_REF, userId)
        let userPath = Database.database().reference(fromURL: strURL)
        userPath.queryOrderedByValue().observe(.value, with:  { (snapshot) in
            var messages = [AnyObject]()
            messages.append(snapshot.value! as AnyObject)
//            print(snapshot.value as Any)
            
            if snapshot.exists() {
                let userDict = snapshot.value as! [String : AnyObject]
                completionHandler(userDict["userProfile"] as! String , userDict["name"] as! String)
            }else {
                completionHandler("" , "")
            }
        })
    }
    
    func getDevProfilePicture(userId: String, completionHandler: @escaping (_ photo: String , _ name : String) -> Void) {
        let strURL = String(format: "%@%@%@", mainRef, USER_DEVELOPERS_REF, userId)
        let userPath = Database.database().reference(fromURL: strURL)
        userPath.queryOrderedByValue().observe(.value, with:  { (snapshot) in
            var messages = [AnyObject]()
            messages.append(snapshot.value! as AnyObject)
//            print(snapshot.value as Any)
            
            if snapshot.exists() {
                let userDict = snapshot.value as! [String : AnyObject]
                completionHandler(userDict["profile"] as! String , userDict["username"] as! String)
            }else {
                completionHandler("" , "")
            }
        })
    }
    
    // MARK:- Chat List Management
    func markMessagesRead(timeStamp: Double, chatID:String, userID:String)  {
        let strURL = String(format: "%@%@/%@", mainRef, CHATS, chatID)
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as! [String: AnyObject]
            for key in Array(dict.keys) {
                var dictTemp = dict[key] as! [String: AnyObject]
                if dictTemp["timestamp"] as! Double == timeStamp {
                    if var isSeen = dictTemp["isSeen"] as? String {
                        if !isSeen.contains(userID) {
                            isSeen = "\(isSeen),\(userID)"
                            dictTemp["isSeen"] = isSeen as AnyObject
                        }
                    }else {
                        dictTemp["isSeen"] = userID as AnyObject?
                    }
                    self.updateMessage(messageDict: dictTemp, key: key, chatID: chatID)
                    break
                }
            }
        }
    }
    
    func markActionMessageRead(timeStamp: Double, chatID:String, userID: String) {
        let strURL = String(format: "%@%@", mainRef, LAST_ACTIONS)
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value) { (snapshot) in
//            print(snapshot)
            if snapshot.exists() {
                let dict = snapshot.value as! [String: AnyObject]
                for key in Array(dict.keys) {
                    var dictTemp = dict[key] as! [String: AnyObject]
                    if dictTemp["projectId"] != nil {
                        if dictTemp["timestamp"] as! Double == timeStamp || dictTemp["projectId"] as! String == chatID {
                            if var isSeen = dictTemp["isSeen"] as? String {
    //                            print(isSeen)
                                if !isSeen.contains(userID) {
                                    isSeen = "\(isSeen),\(userID)"
                                    dictTemp["isSeen"] = isSeen as AnyObject
                                }
                            }else {
                                dictTemp["isSeen"] = userID as AnyObject?
                            }
                            
                            let strURL1 = String(format: "%@%@/%@", self.mainRef, self.LAST_ACTIONS,key)
                            let recentChatPath1 = Database.database().reference(fromURL: strURL1)
                            recentChatPath1.setValue(dictTemp)
                            break
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK:- Message Handling
    func sendMessage(_ message: String, chatID: String, projectID: String, taskID: String, developerID: String, isAttachment: String, audioName : String, image: String, document: String, videoName : String) {
        let strURL = String(format: "%@%@%@", mainRef, CHATS, chatID)
        let conversationPath = Database.database().reference(fromURL: strURL)
        let conversationPath1 = Database.database().reference(fromURL: String(format: "%@%@", mainRef, LAST_ACTIONS))
        
        var dictionary = [String: AnyObject]()
        // dictionary["isLike"] = "0" as AnyObject?
        dictionary["message"] = message as AnyObject
        dictionary["isAttachment"] = isAttachment as AnyObject
        if isAttachment == "audio" {
            dictionary["audio_name"] = audioName as AnyObject
        } else if isAttachment == "image" {
            dictionary["image_name"] = image as AnyObject
        } else if isAttachment == "document" {
            dictionary["document_name"] = document as AnyObject
        } else if isAttachment == "video" {
            dictionary["video_name"] = videoName as AnyObject
        }
        let messageRef = conversationPath.childByAutoId()
        let messageRef1 = conversationPath1.childByAutoId()
        let timeStamp = kCurrentDateTimestamp as AnyObject
        
        dictionary["isSeen"] = UserModel.sharedInstance().user_id as AnyObject
        dictionary["taskId"] = taskID as AnyObject
        dictionary["projectId"] = projectID as AnyObject
        dictionary["receiverUserId"] = developerID as AnyObject
        dictionary["senderUserId"] = UserModel.sharedInstance().user_id  as AnyObject
        dictionary["timestamp"] = timeStamp// as AnyObject//timeStamp
        dictionary["sender_type"] = "client" as AnyObject
        
        messageRef.setValue(dictionary) { (error, ref) in
//            print(ref)
            ref.observeSingleEvent(of: .value) { (snapshot) in
//                print(snapshot)
                let dict = snapshot.value as! [String: AnyObject]
                dictionary["timestamp"]  = (dict["timestamp"] as! Double) as AnyObject
                messageRef1.setValue(dictionary)
            }
        }
    }
    
    func sendProjectChatMessage(_ message: String, chatID: String, projectID: String, isAttachment: String, audioName : String, image: String, document: String, videoName : String) {
        let strURL = String(format: "%@%@%@", mainRef, CHATS, chatID)
        let conversationPath = Database.database().reference(fromURL: strURL)
        let conversationPath1 = Database.database().reference(fromURL: String(format: "%@%@", mainRef, LAST_ACTIONS))
        var dictionary = [String: AnyObject]()
        // dictionary["isLike"] = "0" as AnyObject?
        dictionary["message"] = message as AnyObject
        dictionary["isAttachment"] = isAttachment as AnyObject
        if isAttachment == "audio" {
            dictionary["audio_name"] = audioName as AnyObject
        } else if isAttachment == "image" {
            dictionary["image_name"] = image as AnyObject
        } else if isAttachment == "document" {
            dictionary["document_name"] = document as AnyObject
        } else if isAttachment == "video" {
            dictionary["video_name"] = videoName as AnyObject
        }
        
        let timeStamp = kCurrentDateTimestamp as AnyObject
        
        dictionary["isSeen"] = UserModel.sharedInstance().user_id as AnyObject
        dictionary["senderUserId"] = UserModel.sharedInstance().user_id  as AnyObject
        dictionary["timestamp"] = timeStamp
        dictionary["sender_type"] = "client" as AnyObject
        dictionary["projectId"] = projectID as AnyObject
        
        let messageRef = conversationPath.childByAutoId()
        let messageRef1 = conversationPath1.childByAutoId()
        messageRef.setValue(dictionary)
        
        messageRef.setValue(dictionary) { (error, ref) in
//            print(ref)
            ref.observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                let dict = snapshot.value as! [String: AnyObject]
                dictionary["timestamp"]  = (dict["timestamp"] as! Double) as AnyObject
                messageRef1.setValue(dictionary)
            }
        }
    }
    
    func sendPersonalChatMessage(_ message: String, chatID: String, receiverUserId: String, isAttachment: String, audioName : String, image: String, document: String, videoName : String) {
        let strURL = String(format: "%@%@%@", mainRef, CHATS, chatID)
        let conversationPath = Database.database().reference(fromURL: strURL)
        let conversationPath1 = Database.database().reference(fromURL: String(format: "%@%@", mainRef, LAST_ACTIONS))
        
        var dictionary = [String: AnyObject]()
        dictionary["message"] = message as AnyObject
        dictionary["isAttachment"] = isAttachment as AnyObject
        if isAttachment == "audio" {
            dictionary["audio_name"] = audioName as AnyObject
        } else if isAttachment == "image" {
            dictionary["image_name"] = image as AnyObject
        } else if isAttachment == "document" {
            dictionary["document_name"] = document as AnyObject
        } else if isAttachment == "video" {
            dictionary["video_name"] = videoName as AnyObject
        }
        
        let timeStamp = kCurrentDateTimestamp as AnyObject
        dictionary["receiverUserId"] = receiverUserId as AnyObject
        dictionary["isSeen"] = UserModel.sharedInstance().user_id as AnyObject
        dictionary["senderUserId"] = UserModel.sharedInstance().user_id  as AnyObject
        dictionary["timestamp"] = timeStamp
        dictionary["sender_type"] = "client" as AnyObject
        
        let messageRef = conversationPath.childByAutoId()
        let messageRef1 = conversationPath1.childByAutoId()
        messageRef.setValue(dictionary)
        
        messageRef.setValue(dictionary) { (error, ref) in
//            print(ref)
            ref.observeSingleEvent(of: .value) { (snapshot) in
//                print(snapshot)
                let dict = snapshot.value as! [String: AnyObject]
                dictionary["timestamp"]  = (dict["timestamp"] as! Double) as AnyObject
                messageRef1.setValue(dictionary)
            }
        }
    }
    
    func getListMessages(_ chatID: String, Counter: UInt, completionHandler: @escaping (_ isSuccess: Bool, _ conversations: Array<AnyObject>)-> Void) {
        let strURL = String(format: "%@%@/%@", mainRef, CHATS, chatID)
        var messages = Array<AnyObject>()
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.queryLimited(toLast: Counter).observeSingleEvent(of: .value, with: { (snapShot) in
            if let dict = snapShot.value as? [String: AnyObject] {
                if dict.keys.count > 0 {
                    for key: String in Array(dict.keys) {
                        messages.append(dict[key]!)
                    }
                }
            }
            completionHandler(true, messages)
        })
    }
    
    func ReceiveMessageForTheChat(_ chatID: String, completionHandler:@escaping (_ isSuccess: Bool, _ snap: Array<AnyObject>)-> Void) {
        let strURL = String(format: "%@%@/%@", mainRef, CHATS, chatID)
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.queryLimited(toLast: 1).observe(.childAdded, with:  { (snapshot) in
            var messages = Array<AnyObject>()
            messages.append(snapshot.value! as AnyObject)
//            print(snapshot.value as Any)
            completionHandler(true, messages)
        })
    }
    
    func updateMessage(messageDict: [String: AnyObject], key: String, chatID: String) {
        let strURL = String(format: "%@%@%@/%@", mainRef, CHATS, chatID, key)
        let recentChatPath = Database.database().reference(fromURL: strURL)
        recentChatPath.setValue(messageDict)
    }
    
    func getAllChatFiles(_ chatID: String, completionHandler: @escaping (_ isSuccess: Bool, _ arrImages: [[String:AnyObject]], _ arrAudios:[[String:AnyObject]], _ arrVideos: [[String:AnyObject]], _ arrDocuments:[[String:AnyObject]])-> Void) {
        let strURL = String(format: "%@%@/%@", mainRef, CHATS, chatID)
        var arrImages = [[String:AnyObject]]()
        var arrAudios = [[String:AnyObject]]()
        var arrVideos = [[String:AnyObject]]()
        var arrDocuments = [[String:AnyObject]]()
        
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            if counts > 0 {
                messagePath.queryLimited(toLast: UInt(counts)).observeSingleEvent(of: .value, with: { (snapShot) in
                    if let dict = snapShot.value as? [String: AnyObject] {
                        if dict.keys.count > 0 {
                            for key: String in Array(dict.keys) {
                                if (dict[key]! as! [String:AnyObject])["isAttachment"] as! String == "image" {
                                    arrImages.append(dict[key]! as! [String : AnyObject])
                                }else if (dict[key]! as! [String:AnyObject])["isAttachment"] as! String == "audio" {
                                    arrAudios.append(dict[key]! as! [String : AnyObject])
                                }else if (dict[key]! as! [String:AnyObject])["isAttachment"] as! String == "video" {
                                    arrVideos.append(dict[key]! as! [String : AnyObject])
                                }else if (dict[key]! as! [String:AnyObject])["isAttachment"] as! String == "document" {
                                    arrDocuments.append(dict[key]! as! [String : AnyObject])
                                }
                            }
                        }
                    }
                    completionHandler(true, arrImages, arrAudios, arrVideos, arrDocuments)
                })
            }else {
                completionHandler(true, arrImages, arrAudios, arrVideos, arrDocuments)
            }
        })
    }
    
    func getAllChatAction(_ projectIDs: String,completionHandler: @escaping (_ isSuccess: Bool, _ arrDictData: [[String:AnyObject]])-> Void) {
        let strURL = String(format: "%@%@", mainRef, LAST_ACTIONS)
        var arrDictData = [[String:AnyObject]]()
        
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            if counts > 0 {
                messagePath.queryLimited(toLast: UInt(counts)).observeSingleEvent(of: .value, with: { (snapShot) in
                    if let dict = snapShot.value as? [String: AnyObject] {
                        if dict.keys.count > 0 {
                            for key: String in Array(dict.keys) {
                                let dictionary = dict[key]! as! [String : AnyObject]
                                if let tempProjID = dictionary["projectId"] as? String {
                                    if projectIDs.contains(tempProjID) {
                                        arrDictData.append(dictionary)
                                    }
                                }else {
                                    if let receiverID = dictionary["receiverUserId"] as? String {
                                        if receiverID == UserModel.sharedInstance().user_id! {
                                            arrDictData.append(dictionary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    arrDictData.sort{($0["timestamp"] as! Double) > ($1["timestamp"] as! Double)}
                    completionHandler(true, arrDictData)
                })
            }else {
                completionHandler(true, arrDictData)
            }
        })
    }
    
    func getLast74HoursMessage(_ projectIDs: String, completionHandler: @escaping (_ isSuccess: Bool, _ arrDictData: [[String:AnyObject]])-> Void) {
        let strURL = String(format: "%@%@", mainRef, LAST_ACTIONS)
        var arrDictData = [[String:AnyObject]]()
        print("==> strURL: \(strURL)");
        
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            print("==>counts: \(counts)")
            let DateVar = Date().timeIntervalSince1970
            let timeStamp = Int(DateVar * 1000)
            let timeBefore72Hours = timeStamp - (72 * 3600 * 1000)
            print(">>==>>timestamp: \(timeStamp)")
            print(">>\(timeBefore72Hours)")
            if counts > 0 {
                messagePath.queryLimited(toLast: UInt(counts)).observeSingleEvent(of: .value, with: { (snapShot) in
                    if let dict = snapShot.value as? [String: AnyObject] {
                        if dict.keys.count > 0 {
                            for key: String in Array(dict.keys) {
                                let dictionary = dict[key]! as! [String : AnyObject]
                                if let tempProjID = dictionary["projectId"] as? String {
                                    if projectIDs.contains(tempProjID) {
//                                        if let isSeen = dictionary["isSeen"] as? String {
//                                            if !(isSeen).contains(UserModel.sharedInstance().user_id!) {
//                                                arrDictData.append(dictionary)
//                                            }
//                                        }else {
//                                            arrDictData.append(dictionary)
//                                        }
                                        if let tmstmp = dictionary["timestamp"] as? Int {
                                            if tmstmp >= timeBefore72Hours {
                                                arrDictData.append(dictionary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    arrDictData.sort{($0["timestamp"] as! Double) > ($1["timestamp"] as! Double)}
                    completionHandler(true, arrDictData)
                })
            }
            
        })
    }
    
    func getAllChatEvents(_ projectIDs: String, completionHandler: @escaping (_ isSuccess: Bool, _ arrDictData: [[String:AnyObject]])-> Void) {
        let strURL = String(format: "%@%@", mainRef, LAST_ACTIONS)
        var arrDictData = [[String:AnyObject]]()
        
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            let arrayTemp = projectIDs.components(separatedBy: ",")
            var newTempArrayInt = [Int]()
            for i in 0..<arrayTemp.count {
                newTempArrayInt.append(Int(arrayTemp[i])!)
            }
            if counts > 0 {
                messagePath.queryLimited(toLast: UInt(counts)).observeSingleEvent(of: .value, with: { (snapShot) in
                    if let dict = snapShot.value as? [String: AnyObject] {
                        if dict.keys.count > 0 {
                            //for key: String in Array(dict.keys) {
                            for key in Array(dict.keys) {
                                let dictionary = dict[key]! as! [String : AnyObject]
                                if let tempProjID = dictionary["projectId"] as? String {
                                    //if projectIDs.contains(tempProjID) {
                                    if newTempArrayInt.contains(Int(tempProjID)!) {
                                        if let isSeen = dictionary["isSeen"] as? String {
                                            if !(isSeen).contains(UserModel.sharedInstance().user_id!) {
                                                arrDictData.append(dictionary)
                                            }
                                        }else {
                                            arrDictData.append(dictionary)
                                        }
                                    }
                                }else {
                                    if let receiverID = dictionary["receiverUserId"] as? String {
                                        if receiverID == UserModel.sharedInstance().user_id! {
                                            if let isSeen = dictionary["isSeen"] as? String {
                                                if !(isSeen).contains(UserModel.sharedInstance().user_id!) {
                                                    arrDictData.append(dictionary)
                                                }
                                            }else {
                                                arrDictData.append(dictionary)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    arrDictData.sort{($0["timestamp"] as! Double) > ($1["timestamp"] as! Double)}
                    completionHandler(true, arrDictData)
                })
            }else {
                completionHandler(true, arrDictData)
            }
        })
    }
    
    //MARK:- Message Counter
    func TotalNumberOfMessages(_ chatID: String, completionHandler: @escaping (_ counter: Int)-> Void) {
        let strURL = String(format: "%@%@/%@", mainRef, CHATS, chatID)
        let messagePath = Database.database().reference(fromURL: strURL)
        messagePath.observeSingleEvent(of: .value, with:  { (snapshot) in
            let counts =  Int(snapshot.childrenCount)
            completionHandler(counts)
        })
    }
    
    func StoreLastMessageCount(_ chatID: String) {
        let strURL = String(format: "%@%@/%@/%@", mainRef, LAST_MESSAGE_COUNTS, chatID, UserModel.sharedInstance().user_id!)
        let lastMessageCounts = Database.database().reference(fromURL: strURL)
        self.TotalNumberOfMessages(chatID) { (counter) in
            lastMessageCounts.setValue(counter)
        }
    }
    
    func TotalAndUnreadCounts(_ chatID: String, completionHandler: @escaping (_ TotalCount:Int, _ UnreadCount: Int)-> Void) {
        let strURL = String(format: "%@%@/%@/%@", mainRef, LAST_MESSAGE_COUNTS, chatID, UserModel.sharedInstance().user_id!)
        let lastMessageCounts = Database.database().reference(fromURL: strURL)
        lastMessageCounts.observeSingleEvent(of: .value, with:  { (snapShot) in
            self.TotalNumberOfMessages(chatID, completionHandler: { (counter) in
                if !(((snapShot.value)! as AnyObject) is NSNull) {
                    completionHandler(counter, counter - Int(snapShot.value as! UInt))
                    
                } else {
                    completionHandler(counter, counter)
                }
            })
        })
    }
    
    //MARK:- File Management
    func uploadImage(image: URL!,completionHandler: @escaping (_ url:String, _ fileName:String)-> Void) {
        var data: Data!
        do {
            data = try Data(contentsOf: image)
        } catch {
            print(error.localizedDescription)
            return
        }
        let strURL = String(format: "%@%@%@", storageRef, STORAGE_IMAGE, self.randomString(length: 15))
        let imageDirectory = Storage.storage().reference(forURL: strURL)
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let number = Int.random(in: 0 ... 100000)
        let strImageFileName = "\(number)image.jpg"
                
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = imageDirectory.putData(data, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
            print("Resume")
        }
        
        uploadTask.observe(.pause) { snapshot in
            print("Pause")
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.percentage = percentComplete
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            print("Success")
            imageDirectory.downloadURL { (url, error) in
                completionHandler("\(url!)", strImageFileName)
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File Not Found")
                    break
                case .unauthorized:
                    print("UnAuthorised")
                    break
                case .cancelled:
                    print("Cancel")
                    break
                case .unknown:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func uploadAudio(audioURL: String,completionHandler: @escaping (_ url:String, _ fileName:String)-> Void) {
        
        let localFile = URL(string: "file://\(audioURL)")!
        print(localFile.lastPathComponent)
        let strURL = String(format: "%@%@%@", storageRef, STORAGE_AUDIOS, self.randomString(length: 15))
        let fileDirectory = Storage.storage().reference(forURL: strURL)
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = self.mimeTypeForPath(path: audioURL)
        
        let number = Int.random(in: 0 ... 100000)
        let strAudioFileName = "\(number)audio.\(localFile.pathExtension)"
        
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = fileDirectory.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
            print("Resume")
        }
        
        uploadTask.observe(.pause) { snapshot in
            print("Pause")
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.percentage = percentComplete
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            print("Success")
            fileDirectory.downloadURL { (url, error) in
                completionHandler("\(url!)", strAudioFileName)
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File Not Found")
                    break
                case .unauthorized:
                    print("UnAuthorised")
                    break
                case .cancelled:
                    print("Cancel")
                    break
                case .unknown:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func uploadVideo(videoURL: String,completionHandler: @escaping (_ url:String, _ fileName:String)-> Void) {
        
        let localFile = URL(string: videoURL)!
        print(localFile.lastPathComponent)
        let strURL = String(format: "%@%@%@", storageRef, STORAGE_AUDIOS, self.randomString(length: 15))
        let fileDirectory = Storage.storage().reference(forURL: strURL)

        let number = Int.random(in: 0 ... 100000)
        let strVideoFileName = "\(number)video.\(localFile.pathExtension)"
        
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = self.mimeTypeForPath(path: videoURL)
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = fileDirectory.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
            print("Resume")
        }
        
        uploadTask.observe(.pause) { snapshot in
            print("Pause")
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.percentage = percentComplete
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            print("Success")
            fileDirectory.downloadURL { (url, error) in
                completionHandler("\(url!)", strVideoFileName)
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File Not Found")
                    break
                case .unauthorized:
                    print("UnAuthorised")
                    break
                case .cancelled:
                    print("Cancel")
                    break
                case .unknown:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func uploadDocument(docURL: String ,completionHandler: @escaping (_ url:String, _ fileName:String)-> Void) {
        let localFile = URL(string: docURL)!
        print(localFile.lastPathComponent)
        let strURL = String(format: "%@%@%@", storageRef, STORAGE_DOCUMENTS, self.randomString(length: 15))
        let fileDirectory = Storage.storage().reference(forURL: strURL)
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = self.mimeTypeForPath(path: docURL)
        let number = Int.random(in: 0 ... 100000)
        let strDocFileName = "\(number)document.\(localFile.pathExtension)"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = fileDirectory.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
            print("Resume")
        }
        
        uploadTask.observe(.pause) { snapshot in
            print("Pause")
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.percentage = percentComplete
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            print("Success")
            fileDirectory.downloadURL { (url, error) in
                completionHandler("\(url!)", strDocFileName)
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print("File Not Found")
                    break
                case .unauthorized:
                    print("UnAuthorised")
                    break
                case .cancelled:
                    print("Cancel")
                    break
                case .unknown:
                    break
                default:
                    break
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}
