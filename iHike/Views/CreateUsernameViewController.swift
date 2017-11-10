//
//  CreateUsernameViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
import NotificationBannerSwift

class CreateUsernameViewController: UIViewController,UITextFieldDelegate {

    var user: FUser!
    
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
        
        let fieldTextLength = usernameTextField.text!.characters.count
        
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
        
        
        self.updateUsername()

    }
    
    
    //MARK: - Functions
    
    func updateUsername() {
        
        if self.usernameTextField.text != nil {
            let username = usernameTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            let newDate = dateFormatter().string(from: Date())
            
            updateUser(withValues: [kUSERNAME: username!, kUPDATEDAT: newDate], withBlock: { (success) in
                if success {
                    ProgressHUD.dismiss()
                    
                    self.usernameTextField.text = nil
                    self.user = FUser.currentUser()
                    self.view.endEditing(false)
                    
                    print("Elvis: Username is \(String(describing: username!))")
                    
                    //Proceed to Interests Screen
                    self.performSegue(withIdentifier: Constants.Segue.toAddInterestsFB, sender: self)

                    
                }
            })
        }
    }
    
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
