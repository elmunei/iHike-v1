//
//  EmailSignupVC.swift
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



class EmailSignupVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProgressHUD.dismiss()
    }
   
    
      // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        userEmail = emailTextField.text
        newUserEmail = emailTextField.text
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        ProgressHUD.show("please wait...")
        
        // if fields are empty
        if (emailTextField.text!.isEmpty) {
            
            let banner = StatusBarNotificationBanner(title: "Email address field cannot be empty. Please try again.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        // if incorrect email according to regex
        if !validateEmail(emailTextField.text!) {
            // show alert message
            let banner = StatusBarNotificationBanner(title: "Incorrect email format. Please try again.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        let databaseReff = Database.database().reference().child("Users")
        
        databaseReff.queryOrdered(byChild: "email").queryEqual(toValue: self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)).observe(.value, with: { snapshot in
            if snapshot.exists(){
                ProgressHUD.dismiss()
                //User email exist
                self.performSegue(withIdentifier: Constants.Segue.toLoginEmail, sender: self)
                
                
            }
            else{
                
                self.performSegue(withIdentifier: Constants.Segue.toCreateAccountEmail, sender: self)

                
            }
            
        })
        
        
        
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        self.emailTextField.text = ""
        
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
        if (textField == emailTextField)
        {
            
            emailTextField.resignFirstResponder()
            return true
        }
        
        
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nextBtn.isEnabled = true
        
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
