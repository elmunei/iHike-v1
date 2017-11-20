//
//  UsernameVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 30/10/2017.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import ProgressHUD
import NotificationBannerSwift
import Parse

class UsernameVC: UIViewController,UITextFieldDelegate {
    
    var avatarImage: UIImage?
    
    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var usernameTxt: CustomizableTextfield!{
        didSet{
            usernameTxt.delegate = self
        }
    }
    @IBOutlet weak var nextBtn: CustomizableButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Elvis: you are on UsernameVC")
//        self.getUserInfo()
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(UsernameVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Actions
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty  {
            
            let banner = StatusBarNotificationBanner(title: "Username cannot be empty. Please try again.", style: .danger)
            banner.show()
            
            
            ProgressHUD.dismiss()
            return
        }
        
        let fieldTextLength = usernameTxt.text!.count
        
        if  fieldTextLength < 4  {
            let banner = StatusBarNotificationBanner(title: "Username is too short.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        if  fieldTextLength > 8  {
            let banner = StatusBarNotificationBanner(title: "Username is too long.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        // save username in user profile
        let user = PFUser.current()!
        user.username = usernameTxt.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        user.saveInBackground (block: { (success, error) -> Void in
            if success{
                ProgressHUD.dismiss()
                // hide keyboard
                self.view.endEditing(true)
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                ProgressHUD.dismiss()
                
                //Proceed to Interests Screen
                self.performSegue(withIdentifier: Constants.Segue.toAddInterests, sender: self)
                
                
                
                
            } else {
                
                // show alert message
                let banner = StatusBarNotificationBanner(title:  error!.localizedDescription, style: .danger)
                banner.show()
                
                
                
            }
            
        })
        
    }
    
    //MARK: - Functions
    
    func updateUsername() {
//
//        if self.usernameTxt.text != nil {
//            let username = usernameTxt.text
//            let newDate = dateFormatter().string(from: Date())
//
//            updateUser(withValues: [kUSERNAME: username!, kUPDATEDAT: newDate], withBlock: { (success) in
//                if success {
//                    ProgressHUD.dismiss()
//
//                    self.usernameTxt.text = nil
//                    self.user = FUser.currentUser()
//                    self.view.endEditing(false)
//
//                    print("Elvis: Username is \(String(describing: username!))")
//
//                    //Proceed to Interests Screen
//                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterestsVC") as! InterestsVC
//
//                    self.present(vc, animated: true, completion: nil)
//
//                }
//            })
//        }
    }
    
    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if (textField == usernameTxt)
        {
            usernameTxt.resignFirstResponder()
        }
        return false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 80)
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue: 80)
        
        
        
        
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterSetNotAllowed = CharacterSet.punctuationCharacters
        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
            return false
        } else {
            return true
        }
        
    }
//    func getUserInfo() {
//
//        self.user = FUser.currentUser()
//
//        if user.objectId != FUser.currentId() {
//
//        }
//
//        let placeHolderImage = UIImage(named: "pp")
//
//        self.pp.image = maskRoundedImage(image: placeHolderImage!, radius: Float(placeHolderImage!.size.width / 2))
//
//
//
//
//        if user.avatar != "" {
//
//            imageFromData(pictureData: user.avatar, withBlock: {
//                image in
//
//                self.pp.image = maskRoundedImage(image: image!, radius: Float(image!.size.width / 2))
//                //self.bg.image = bgImage(image: image!)
//            })
//
//        }
//    }
    
}


