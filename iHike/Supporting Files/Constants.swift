//
//  Constants.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Constants {
    
    struct Segue {
        static let toCreateFacebookVerification = "toCreateFacebookVerification"
        static let toCreateEmailVerification = "toCreateEmailVerification"
        static let toCreateAccountEmail = "toCreateAccountEmail"
        static let toLoginEmail = "toLoginEmail"
        static let toAddPhotoUsername = "toAddPhotoUsername"
        static let toAddInterests = "toAddInterests"
        static let toAddInterestsFB = "toAddInterestsFB"
        static let toAddLocation = "toAddLocation"

    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
        static let uid = "objectId"
        static let username = "username"
    }
    
}

var firebase = Database.database().reference()
let userDefaults = UserDefaults.standard

//IDS and Keys
public let kONESIGNALAPPID = ""
public let kSINCHKEY = ""
public let kSINCHSECRET = ""

//FUser
public let kOBJECTID = "objectId"
public let kUSER = "Users"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kEMAIL = "email"
public let kFACEBOOK = "facebook"
public let kLOGINMETHOD = "loginMethod"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstname"
public let kLASTNAME = "lastname"
public let kFULLNAME = "fullname"
public let kUSERNAME = "username"
public let kAVATAR = "avatar"
public let kCURRENTUSER = "currentUser"
public let kCURRENTUSERLOCATION = "userlocation"
public let kCURRENTUSERINTERESTS = "userinterests"

//typing
public let kTYPINGPATH = "Typing"

//
public let kAVATARSTATE = "avatarState"
public let kFILEREFERENCE = "gs://ihike-d1dfb.appspot.com"
public let kFIRSTRUN = "firstRun"
public let kNUMBEROFMESSAGES = 40
public let kMAXDURATION = 5.0
public let kAUDIOMAXDURATION = 10.0
public let kSUCCESS = 2

//Post
public let kPOSTIMAGE = "userpostimage"
public let kPOSTERAVATAR = "posteravatar"
public let kPOSTDESCRIPTION = "postdescription"
public let kPOSTRANK = "postrank"
public let kPOSTDISTANCE = "postdistance"
public let kPOSTLOCATION = "postlocation"
public let kPOSTCREATEDTIMESTAMP = "postcreatedtimestamp"
public let kPOSTLIKES = "postlikes"
public let kPOSTCOMMENTS = "postcomments"
public let kPOSTTAGS = "posttags"

//recent
public let kRECENT = "Recent"
public let kCHATROOMID = "chatRoomID"
public let kUSERID = "userId"
public let kDATE = "date"
public let kPRIVATE = "private"
public let kGROUP = "group"
public let kGROUPID = "groupId"
public let kRECENTID = "recentId"
public let kMEMBERS = "members"
public let kDISCRIPTION = "discription"
public let kLASTMESSAGE = "lastMessage"
public let kCOUNTER = "counter"
public let kTYPE = "type"
public let kWITHUSERUSERNAME = "withUserUserName"
public let kWITHUSERUSERID = "withUserUserID"
public let kOWNERID = "ownerID"
public let kSTATUS = "status"
public let kMESSAGE = "Message"
public let kMESSAGEID = "messageId"
public let kNAME = "name"
public let kSENDERID = "senderId"
public let kSENDERNAME = "senderName"
public let kTHUMBNAIL = "thumbnail"

//Friends
public let kFRIEND = "friends"
public let kFRIENDID = "friendId"

//message types
public let kPICTURE = "picture"
public let kTEXT = "text"
public let kVIDEO = "video"
public let kAUDIO = "audio"
public let kLOCATION = "location"

//coordinates
public let kLATITUDE = "latitude"
public let kLONGITUDE = "longitude"


//message status
public let kDELIVERED = "Delivered"
public let kREAD = "Read"

//push
public let kDEVICEID = "deviceId"



//backgroung color
public let kRED = "red"
public let kGREEN = "green"
public let kBLUE = "blue"
