//
//  MyProfileViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 08/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD
import NotificationBannerSwift

class MyProfileViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    
    var user: FUser!
    var avatarImage: UIImage?
    // MARK: - Outlets
    
    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var usernameTxt: CustomizableTextfield!{
        didSet{
            usernameTxt.delegate = self
        }
    }
    @IBOutlet weak var nextBtn: CustomizableButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // round avatar
        pp.layer.cornerRadius = pp.frame.size.width / 2
        pp.clipsToBounds = true
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        pp.isUserInteractionEnabled = true
        pp.addGestureRecognizer(avaTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: - Navigation

    @IBAction func nextBtnTapped(_ sender: Any) {
        
        ProgressHUD.show("Please wait...", interaction: false)
        
        // if no pp
        if  pp.image! == UIImage(named: "pp")! {
            
            
            // show alert message
            let banner = StatusBarNotificationBanner(title:  "Please add a profile picture", style: .danger)
            banner.show()
            
            ProgressHUD.dismiss()
           
            
            return
        }
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if textfields are empty
        if usernameTxt.text!.isEmpty  {
            
            let banner = StatusBarNotificationBanner(title: "Username cannot be empty. Please try again.", style: .danger)
            banner.show()
            
            
            ProgressHUD.dismiss()
            return
        }
        
        let fieldTextLength = usernameTxt.text!.characters.count
        
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
        
        updateUsername()


    }
    
    
    //MARK: - Functions
    
    func updateUsername() {
        
        if self.usernameTxt.text != nil && self.pp.image != nil {
            
            let username = usernameTxt.text?.trimmingCharacters(in: CharacterSet.whitespaces)
            let newDate = dateFormatter().string(from: Date())
            let image = UIImageJPEGRepresentation(pp.image!, 0.5)
            let avatar = image!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            updateUser(withValues: [kUSERNAME: username!,kAVATAR: avatar, kUPDATEDAT: newDate], withBlock: { (success) in
                if success {
                    ProgressHUD.dismiss()
                    
                    self.usernameTxt.text = nil
                    self.user = FUser.currentUser()
                    self.view.endEditing(false)
                    
                    print("Elvis: Username is \(String(describing: username))")
                    
                    //Proceed to Interests Screen
                    self.performSegue(withIdentifier: Constants.Segue.toAddInterests, sender: self)

                    
                }
            })
        }
    }
    
    
    func updateAvatarImage() {
        
        if self.avatarImage != nil {
            
            let image = UIImageJPEGRepresentation(pp.image!, 0.5)
            let avatar = image!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            let newDate = dateFormatter().string(from: Date())
            
            updateUser(withValues: [kAVATAR: avatar, kUPDATEDAT : newDate], withBlock: { (success) in
                
                if success {
                    self.user = FUser.currentUser()
                }
            })
        }
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterSetNotAllowed = CharacterSet.punctuationCharacters
        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
            return false
        } else {
            return true
        }
        
    }
    
    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       self.pp.image = (info[UIImagePickerControllerEditedImage] as! UIImage)

        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
