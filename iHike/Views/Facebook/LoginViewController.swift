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
import Parse
import ParseFacebookUtilsV4
import NotificationBannerSwift
import ProgressHUD



class LoginViewController: UIViewController {

     var firstLoad: Bool?
    
    var fullnameFB = String()
    var idFB = String()
    var emailFB = String()
    var isFBSignUp = Bool()
   
    @IBOutlet weak var loadingCube: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadingCube.loadGif(name: "Cube")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createfacebookUser()

        
        loadingCube.loadGif(name: "Cube")
   
        
    }
    
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func fbButtonTapped() {
        
        
        
        
        
//        let permissions = [ "public_profile" ]
//
//        PFFacebookUtils.logInInBackground(withReadPermissions: permissions) { (user, error) in            if let user = user {
//            if user.isNew {
//                print("User signed up and logged in through Facebook!")
//            } else {
//                print("User logged in through Facebook!")
//            }
//        } else {
//            print("Uh oh. The user cancelled the Facebook login.")
//            }
//        }
        
        
    }
    
    func createfacebookUser() {
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: {
                        result, error in
            
                        if error != nil {
                            print("error logging in with facebook \(String(describing: error?.localizedDescription))")
                            return
                        }
            if error != nil { //if theres an error
                print(error!)
            } else if (result?.isCancelled)! { // if user cancels the sign up request
                print("user cancelled login")
            } else {
                PFFacebookUtils.logInInBackground(with: result!.token!) { (user, error) in
                    if error == nil {
                        
                        if let user = user {
                            
                            if user.isNew {
                                self.createUserFromFacebook(withBlock: { (result, avatarImage) in

                                
                                print("User signed up and logged in through Facebook!")
                                let user = PFUser()
                                user.username = " "
                                user.email = self.emailFB.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
                                user["fullname"] = self.fullnameFB.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
                                    user.password = self.idFB
                                user["profilepicture"] = avatarImage
                                user["gender"] = ""
                                user["interests"] = ""
                                user["profiledescription"] = ""
                                user["friends"] = ""
                                user["web"] = ""
                                user["location"] = ""
                                user["loginMethod"] = "facebook"
                                
                                    
                                    // save data in server
                                    user.signUpInBackground { (success, error) -> Void in
                                        // Stop the spinner
                                        ProgressHUD.dismiss()
                                        if success {
                                            print("registered")
                                            
                                            
                                            // remember logged in user
                                            UserDefaults.standard.set(user.username, forKey: "username")
                                            UserDefaults.standard.synchronize()
                                            
                                             self.goToApp()
                                            
                                            
                                        } else {
                                            // show alert message
                                            let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                                            banner.show()
                                            
                                            ProgressHUD.dismiss()
                                            
                                            
                                            return
                                            
                                        }
                                    }
                                    })
                                
                            } else {
                                print("User logged in through Facebook!")
                                let initialViewController = UIStoryboard.initialViewController(for: .main)
                                    self.view.window?.rootViewController = initialViewController
                                    self.view.window?.makeKeyAndVisible()
                            }
                            
                            if (result?.grantedPermissions.contains("email"))! {
                                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name"]) {
                                    graphRequest.start(completionHandler: { (connection, result, error) in
                                        if error != nil {
                                            print(error?.localizedDescription ?? String())
                                        } else {
                                            if let userDetails = result as? [String: String]{
                                                print(userDetails)
                                                self.fullnameFB = userDetails["name"]!
                                                self.idFB = userDetails["id"]!
                                                self.emailFB = userDetails["email"]!
                                                self.isFBSignUp = true
                                            }
                                        }
                                    })
                                }
                            } else {
                                print("didnt get email")
//                                self.createAlert(title: "Facebook Sign Up", message: "To signup with Facebook, we need your email address")
                            }
                            
                        } else {
                            print("Error while trying to login using Facebook: \(error?.localizedDescription ?? "---")")
                        }
                    } else {
                        print(error?.localizedDescription ?? String())
                    }
                }
            }
        
    })
    }

    
//    func fbButtonTapped() {
//        print("ELVIS: Facebook button pressed")
//        
//        let fbLoginManager = FBSDKLoginManager()
//        
//        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: {
//            result, error in
//            
//            if error != nil {
//                print("error logging in with facebook \(String(describing: error?.localizedDescription))")
//                return
//            }
//            
//            
//            if result?.token != nil {
//                
//                self.loadingCube.loadGif(name: "Cube")
//
//                let credentials = FacebookAuthProvider.credential(withAccessToken: result!.token.tokenString)
//                
//                Auth.auth().signIn(with: credentials, completion: { (firuser, error) in
//                    
//                    if error != nil {
//                        
//                        print("Error logging in with facebook \(String(describing: error?.localizedDescription))")
//                        return
//                    }
//                    
//                    self.isUserRegistered(userId: firuser!.uid, withBlock: { (isRegistered) in
//                        
//                        if !isRegistered {
//                            ProgressHUD.dismiss()
//                            //do only when user is not registered yet
//                            self.createFirebaseUserFromFacebook(withBlock: { (result, avatarImage) in
//                                
//                                let fUser = FUser(_objectId: firuser!.uid, _pushId: "", _createdAt: Date(), _updatedAt: Date(), _email: firuser!.email!, _username: result["name"] as! String, _fullname: result["name"] as! String, _avatar: avatarImage,_location: "" ,_interests: [" "], _loginMethod: kFACEBOOK, _friends: [])
//                                
//                                saveUserLocally(fUser: fUser)
//                                saveUserInBsckground(fUser: fUser, completion: { (error) in
//                                    
//                                    if error == nil {
//                                        
//                                        self.goToApp()
//                                    }
//                                    
//                                })
//                                
//                            })
//                            
//                        } else {
//                            
//                            ProgressHUD.dismiss()
//                            //login user and dont reg him
//                            fetchUser(userId: firuser!.uid, withBlock: { (success) in
//                                
//                                if success {
//                                    
//                                    ProgressHUD.dismiss()
//                                    
//                                    //go to app
//                                    let initialViewController = UIStoryboard.initialViewController(for: .main)
//                                    self.view.window?.rootViewController = initialViewController
//                                    self.view.window?.makeKeyAndVisible()
//                                }
//                                
//                            })
//                            
//                        }
//                        
//                    })
//                    
//                })
//            }
//            
//        })
//        
//
//    }
//    
//   
//    
    func createUserFromFacebook(withBlock: @escaping (_ result: NSDictionary, _ avatarImage: String) -> Void) {
        
        
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name"]).start { (connection, result, error) in
            
            
            if error != nil {
                ProgressHUD.dismiss()
                print("Error facebook request \(String(describing: error?.localizedDescription))")
                return
            }
            
            
            if let facebookId = (result as! NSDictionary)["id"] as? String {
                
                let avatarUrl = "http://graph.facebook.com/\(facebookId)/picture?type=normal"
                
                self.getImageFromURL(url: avatarUrl, withBlock: { (image) in
                    
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
    func getImageFromURL(url: String, withBlock: @escaping (_ image: UIImage?) -> Void) {
        
        let url = NSURL(string: url)
        
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        
        downloadQueue.async {
            
            let data = NSData(contentsOf: url! as URL)
            
            let image: UIImage!
            
            if data != nil {
                
                
                image = UIImage(data: data! as Data)
                
                DispatchQueue.main.async {
                    
                    withBlock(image!)
                }
                
            }
        }
        
    }
    
//
//    func isUserRegistered(userId: String, withBlock: @escaping (_ result: Bool) -> Void) {
//        
//        firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value, with: {
//            snapshot in
//            
//            if snapshot.exists() {
//                
//                withBlock(true)
//                
//            } else {
//                
//                withBlock(false)
//            }
//            
//        })
//        
//    }
//    
   
    
    func goToApp() {
//        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId" : FUser.currentId()])
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



