//
//  LoginViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase
import NotificationBannerSwift
import ProgressHUD


typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {

     var firstLoad: Bool?
   
    @IBOutlet weak var loadingCube: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadingCube.loadGif(name: "Cube")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingCube.loadGif(name: "Cube")
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if  userDefaults.object(forKey: kCURRENTUSER) != nil  {
                // User is signed in. Show home screen
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            } else {
                // No User is signed in. Show user the login screen
               
            }
        }
        
        fbButtonTapped()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    func fbButtonTapped() {
        print("ELVIS: Facebook button pressed")
        
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: {
            result, error in
            
            if error != nil {
                print("error logging in with facebook \(String(describing: error?.localizedDescription))")
                return
            }
            
            
            if result?.token != nil {
                
                self.loadingCube.loadGif(name: "Cube")

                let credentials = FacebookAuthProvider.credential(withAccessToken: result!.token.tokenString)
                
                Auth.auth().signIn(with: credentials, completion: { (firuser, error) in
                    
                    if error != nil {
                        
                        print("Error logging in with facebook \(String(describing: error?.localizedDescription))")
                        return
                    }
                    
                    self.isUserRegistered(userId: firuser!.uid, withBlock: { (isRegistered) in
                        
                        if !isRegistered {
                            ProgressHUD.dismiss()
                            //do only when user is not registered yet
                            self.createFirebaseUserFromFacebook(withBlock: { (result, avatarImage) in
                                
                                let fUser = FUser(_objectId: firuser!.uid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _email: firuser!.email!, _username: result["name"] as! String, _fullname: result["name"] as! String, _avatar: avatarImage,_location: "" ,_interests: [" "], _loginMethod: kFACEBOOK, _friends: [])
                                
                                saveUserLocally(fUser: fUser)
                                saveUserInBsckground(fUser: fUser, completion: { (error) in
                                    
                                    if error == nil {
                                        
                                        self.goToApp()
                                    }
                                    
                                })
                                
                            })
                            
                        } else {
                            
                            ProgressHUD.dismiss()
                            //login user and dont reg him
                            fetchUser(userId: firuser!.uid, withBlock: { (success) in
                                
                                if success {
                                    
                                    ProgressHUD.dismiss()
                                    
                                    //go to app
                                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                                    self.view.window?.rootViewController = initialViewController
                                    self.view.window?.makeKeyAndVisible()
                                }
                                
                            })
                            
                        }
                        
                    })
                    
                })
            }
            
        })
        

    }
    
   
    
    func createFirebaseUserFromFacebook(withBlock: @escaping (_ result: NSDictionary, _ avatarImage: String) -> Void) {
        
        
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name, locale"]).start { (connection, result, error) in
            
            
            if error != nil {
                ProgressHUD.dismiss()
                print("Error facebook request \(String(describing: error?.localizedDescription))")
                return
            }
            
            
            if let facebookId = (result as! NSDictionary)["id"] as? String {
                
                let avatarUrl = "http://graph.facebook.com/\(facebookId)/picture?width=640&height=640"
                
                getImageFromURL(url: avatarUrl, withBlock: { (image) in
                    
                    //convert avatar image to string
                    let image = UIImageJPEGRepresentation(image!, 0.5)
                    let avatarString = image!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    
                    
                    withBlock(result as! NSDictionary, avatarString)
                })
                
            } else {
                
                print("Facebook request error, no facebook id")
                
                //return result only
                withBlock(result as! NSDictionary, "")
                
            }
            
        }
        
    }
    
    
    func isUserRegistered(userId: String, withBlock: @escaping (_ result: Bool) -> Void) {
        
        firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value, with: {
            snapshot in
            
            if snapshot.exists() {
                
                withBlock(true)
                
            } else {
                
                withBlock(false)
            }
            
        })
        
    }
    
   
    
    func goToApp() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId" : FUser.currentId()])
        ProgressHUD.dismiss()
        
        //go to app
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "CreateUsernameViewController") as! CreateUsernameViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    //firstRun check
    func setUserDefaults() {
        
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad! {
            
            userDefaults.set(true, forKey: kFIRSTRUN)
            userDefaults.set(true, forKey: kAVATARSTATE)
            
            userDefaults.set(1.0, forKey: kRED)
            userDefaults.set(1.0, forKey: kGREEN)
            userDefaults.set(1.0, forKey: kBLUE)
            
            userDefaults.synchronize()
        }
        
    }
    
    
}



