//
//  ResetPassword.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 20/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse
import NotificationBannerSwift
import ProgressHUD

class ResetPassword: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resetPwd: CustomizableTextfield!{
        didSet{
            resetPwd.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetPwd.becomeFirstResponder()
        resetPwd.enablesReturnKeyAutomatically = true
    }

    // MARK: - Navigation
    
    
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        
        performAction()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       performAction()
        
        
        return true
    }
    
    func performAction() {
        
        // if fields are empty
        if ( resetPwd.text!.isEmpty ) {
            
            let banner = StatusBarNotificationBanner(title: "Email address missing! Please try again.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
        
        // if incorrect email according to regex
        if !validateEmail(resetPwd.text!) {
            // show alert message
            let banner = StatusBarNotificationBanner(title: "Incorrect email format. Please try again.", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
            
            return
        }
      
        
        
        // request for reseting password
        PFUser.requestPasswordResetForEmail(inBackground: resetPwd.text!.trimmingCharacters(in: CharacterSet.whitespaces)) { (success, error) -> Void in
            ProgressHUD.show("please wait...")

            if success {
                
                let alertController = UIAlertController(title: "Success", message: "A reset password link has been sent to \(String(describing: self.resetPwd.text!))", preferredStyle: .alert)
                
                let okay = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    self.resetPwd.text = ""
                    ProgressHUD.dismiss()
                    self.view.endEditing(true)
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okay)
                self.present(alertController, animated: true, completion: nil)
                
                
                
                
                
            } else {
                
                let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                banner.show()
                
                ProgressHUD.dismiss()
            }
        }
        
    }
    
    // regex restrictions for email textfield
    func validateEmail (_ email : String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]{4}+@[A-Za-z0-9.-]+\\.[A-Za-z]{3}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }

}
