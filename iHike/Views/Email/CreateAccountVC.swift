//
//  CreateAccountVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 09/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import MobileCoreServices
import ProgressHUD
import NotificationBannerSwift
import Parse

var newUserEmail: String?

class CreateAccountVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

     // MARK: - Navigation
    
    @IBOutlet weak var passwordTxt: UITextField!{
        didSet{
            passwordTxt.delegate = self
        }
    }
    @IBOutlet weak var fullnametxt: UITextField!{
        didSet{
            fullnametxt.delegate = self
        }
    }
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.delegate = self
        }
    }
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.text  = newUserEmail
        fullnametxt.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        performAction()
        

        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.emailTxt.text = ""
        self.passwordTxt.text = ""
        self.fullnametxt.text = ""

        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Functions

    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTxt)
        {
            fullnametxt.becomeFirstResponder()
            return true
        } else if (textField == fullnametxt) {
            passwordTxt.becomeFirstResponder()
            return true
        }else if (textField == passwordTxt) {
            performAction()
            return true
        }
        
        
        return false
    }
    
    func performAction() {
        
        ProgressHUD.show("please wait...")
        
        // if fields are empty
        if (emailTxt.text!.isEmpty || fullnametxt.text!.isEmpty || passwordTxt.text!.isEmpty ) {
            
            let banner = StatusBarNotificationBanner(title: "One or more fields is empty. Please try again.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        // if incorrect email according to regex
        if !validateEmail(emailTxt.text!) {
            // show alert message
            let banner = StatusBarNotificationBanner(title: "Incorrect email format. Please try again.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        
        // send data to server to related columns
        let user = PFUser()
        user.username = " "
        user.email = emailTxt.text!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
        user.password = passwordTxt.text
        user["fullname"] = fullnametxt.text!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
        user["gender"] = ""
        user["interests"] = [""]
        user["profiledescription"] = ""
        user["friends"] = [""]
        user["web"] = ""
        user["location"] = ""
        user["loginMethod"] = "email"
        
        
        
        
        
        // save data in server
        user.signUpInBackground { (success, error) -> Void in
            // Stop the spinner
            ProgressHUD.dismiss()
            if success {
                print("registered")
                
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                self.performSegue(withIdentifier: Constants.Segue.toAddPhotoUsername, sender: self)
                
                
                
                
            } else {
                // show alert message
                let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                banner.show()
                
                ProgressHUD.dismiss()
                
                
                return
                
            }
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.isEnabled = true
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        
    }
    
    // regex restrictions for email textfield
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
 

}
