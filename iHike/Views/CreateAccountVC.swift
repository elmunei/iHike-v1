//
//  CreateAccountVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 09/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import ProgressHUD
import NotificationBannerSwift

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
        
        
        FUser.registerUserWith(email: emailTxt.text!.trimmingCharacters(in: CharacterSet.whitespaces), password: passwordTxt.text!, fullname: fullnametxt.text!, username: fullnametxt.text!.trimmingCharacters(in: CharacterSet.whitespaces), location: " ", interests: [""], avatar: " ", withBlock: { (success) in
            
            if success {
                
                ProgressHUD.dismiss()
                
                //post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId" : FUser.currentId()])
                
                //go to username screen
               
                self.performSegue(withIdentifier: Constants.Segue.toAddPhotoUsername, sender: self)
                
            }
        })
        
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
            passwordTxt.resignFirstResponder()
            return true
        }
        
        
        return false
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
