//
//  EmailSignupVC.swift
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



class EmailSignupVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    @IBOutlet weak var emailTextField: UITextField!{
        didSet{
            emailTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ProgressHUD.dismiss()
        emailTextField.becomeFirstResponder()

    }
   
    
      // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        userEmail = emailTextField.text
        newUserEmail = emailTextField.text
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        
        performAction()
        
    }
    
    func performAction() {
        
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
        
        
        usernameIsTaken(email: emailTextField.text!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces))
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        self.emailTextField.text = ""
        
        // hide keyboard when pressed cancel
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Functions
    
    //Email Check if exists
    func usernameIsTaken(email: String) -> Bool {
        
        //bool to see if username is taken
        var exists: Bool = false
        
        let enteredEmailAddress = email
        
        // Then query and compare
        let query: PFQuery = PFUser.query()!
        query.whereKey("email", equalTo: enteredEmailAddress)
        query.findObjectsInBackground(block: {
            (objects, error) in
            if error == nil {
                if (objects!.count > 0){
                    exists = true
                    print("user email is exists")
                    self.performSegue(withIdentifier: Constants.Segue.toLoginEmail, sender: self)

                } else {
                    print("user email is new ")
                    self.performSegue(withIdentifier: Constants.Segue.toCreateAccountEmail, sender: self)
                }
            } else {
                print("error")
            }
        })
        
        return exists
    }

 // hide keyboard func
 @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
 self.view.endEditing(true)
 }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        performAction()

        
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nextBtn.isEnabled = true
        
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        
        
    }
    
    // regex restrictions for email textfield
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }

}
