//
//  SigninViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 10/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase
import ProgressHUD
import NotificationBannerSwift

var userEmail: String?

class SigninViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    
    // MARK: - Outlets
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.delegate = self
        }
    }
    @IBOutlet weak var password: UITextField!{
        didSet{
            password.delegate = self
        }
    }
    @IBOutlet weak var signinBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTxt.text = userEmail
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        self.emailTxt.text = ""
        self.password.text = ""

        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
 
    
    // MARK: - Actions

    @IBAction func signinBtnTapped(_ sender: Any) {
        
        ProgressHUD.show("please wait...")
        
        // if fields are empty
        if (emailTxt.text!.isEmpty && password.text!.isEmpty ) {
            
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
        
        FUser.loginUserWith(email: emailTxt.text!.trimmingCharacters(in: CharacterSet.whitespaces), password: password.text!, withBlock: { (success) in
            
            ProgressHUD.dismiss()
            
            if success {
                
                self.emailTxt.text = nil
                self.password.text = nil
                self.view.endEditing(false)
                
                //go to app
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
            
        })
        
    }
    

    // MARK: - Functions
    
    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTxt)
        {
            
            password.becomeFirstResponder()
            
            return true
        } else if (textField == password) {
            
            password.resignFirstResponder()
            
            return true
        }
        
        
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        signinBtn.isEnabled = true
        
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
