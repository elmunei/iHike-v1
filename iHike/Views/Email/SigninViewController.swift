//
//  SigninViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 10/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse
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
        signinBtn.isEnabled = false
        password.becomeFirstResponder()
        password.enablesReturnKeyAutomatically = true
        emailTxt.text = userEmail
    }

    override func viewWillAppear(_ animated: Bool) {
        ProgressHUD.dismiss()

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
        
       performAction()
        
    }
    
    func performAction() {
        
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
        
        let query: PFQuery = PFUser.query()!
        query.whereKey("email", equalTo: emailTxt.text!.trimmingCharacters(in: CharacterSet.whitespaces))
        query.findObjectsInBackground(block: {
            (objects, error) in
            if(error == nil){
                if (objects!.count > 0) {
                    let object = objects![0]
                    let userName = object["username"] as! String
                    PFUser.logInWithUsername(inBackground: userName, password: self.password.text!) { (user, error)  -> Void in
                        
                         if error == nil {
                        // remember user or save in App Memory did the user login or not
                        UserDefaults.standard.set(user!.username, forKey: "username")
                        UserDefaults.standard.synchronize()
                        
                        ProgressHUD.show("Please wait...", interaction: false)
                        self.emailTxt.text = nil
                        self.password.text = nil
                        self.view.endEditing(false)
                        
                        //go to app
                        let initialViewController = UIStoryboard.initialViewController(for: .main)
                        self.view.window?.rootViewController = initialViewController
                        self.view.window?.makeKeyAndVisible()
                         } else {
                            
                            // show alert message
                            let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                            banner.show()
                            
                            ProgressHUD.dismiss()
                        }
                    }
                }
            } else {
                
                print("Error in retrieving \(String(describing: error))")
            }
            
        })
        

    }
    
    
    @IBAction func resetPassword(_ sender: Any) {
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
            
            performAction()

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
