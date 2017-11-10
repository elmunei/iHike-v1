//
//  FPost.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 04/11/2017.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import NotificationBannerSwift
import ProgressHUD

class Post {

    let objectId: String
    
    let postcreatedtimestamp: NSNumber
    var postupdatedtimestamp: NSNumber
    var ref: DatabaseReference!
    var username: String
    var userpostimage: String
    var postdescription: String
    var postrank: String
    var postdistance: String
    var postlocation: String
   
    
    //MARK: Initializers
    
    init(_objectId: String,  _postcreatedtimestamp: NSNumber, _postupdatedtimestamp: NSNumber, _username: String,_userpostimage: String, _postdescription: String,_postrank: String,_postdistance:String,_postlocation: String) {
        
        objectId = _objectId
        
        postcreatedtimestamp = _postcreatedtimestamp
        postupdatedtimestamp = _postupdatedtimestamp
        
        username = _username
        userpostimage = _userpostimage
        postdescription = _postdescription
        postrank = _postrank
        postdistance = _postdistance
        postlocation = _postlocation
     
        self.ref = Database.database().reference()
        
    }
    
    init(snapshot:DataSnapshot!) {
        
        objectId = (snapshot.value! as! NSDictionary)[kOBJECTID] as! String
        
        postcreatedtimestamp = (snapshot.value! as! NSDictionary)[kPOSTCREATEDTIMESTAMP] as! NSNumber
        postupdatedtimestamp = (snapshot.value! as! NSDictionary)[kUPDATEDAT] as! NSNumber
        username = (snapshot.value! as! NSDictionary)[kUSERNAME] as! String
        userpostimage = (snapshot.value! as! NSDictionary)[kPOSTIMAGE] as! String
        postdescription = (snapshot.value! as! NSDictionary)[kPOSTDESCRIPTION] as! String
        postrank = (snapshot.value! as! NSDictionary)[kPOSTRANK] as! String
        postdistance = (snapshot.value! as! NSDictionary)[kPOSTDISTANCE] as! String
        postlocation = (snapshot.value! as! NSDictionary)[kPOSTLOCATION] as! String
        self.ref = snapshot.ref

       
        
    }
    
    func toAnyObject()->[String: Any] {
        return [kOBJECTID:self.objectId,kPOSTCREATEDTIMESTAMP:self.postcreatedtimestamp,kUPDATEDAT : self.postupdatedtimestamp,kUSERNAME:self.username,kPOSTIMAGE:self.userpostimage,kPOSTDESCRIPTION:self.postdescription, kPOSTRANK: self.postrank,kPOSTDISTANCE: self.postdistance, kPOSTLOCATION: self.postlocation ]
    }
    

    
    

}
