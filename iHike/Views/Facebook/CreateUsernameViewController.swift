//
//  CreateUsernameViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import ProgressHUD
import NotificationBannerSwift
import Parse

class CreateUsernameViewController: UIViewController,UITextFieldDelegate {

    
    // MARK: - Outlets
    
    
    
    
    @IBOutlet weak var usernameTextField: CustomizableTextfield!{
        didSet{
            usernameTextField.delegate = self
        }
    }
    @IBOutlet weak var nextButton: CustomizableButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(CreateUsernameViewController.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Actions
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTextField.text!.isEmpty  {
            
            let banner = StatusBarNotificationBanner(title: "Username cannot be empty. Please try again.", style: .danger)
            banner.show()
            
            
            ProgressHUD.dismiss()
            return
        }
        
        let fieldTextLength = usernameTextField.text!.count
        
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
        user.username = usernameTextField.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
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

    
    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if (textField == usernameTextField)
        {
            usernameTextField.resignFirstResponder()
        }
        return false
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterSetNotAllowed = CharacterSet.punctuationCharacters
        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
            return false
        } else {
            return true
        }
        
    }
    
}
