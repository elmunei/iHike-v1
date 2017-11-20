//
//  MyProfileViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 08/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD
import NotificationBannerSwift

class MyProfileViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate  {

    
  
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
        
    perfomAction()

    }
    
    
    //MARK: - Functions
    
    func perfomAction() {
        
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
        
        let fieldTextLength = usernameTxt.text!.count
        
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
        
        // save username/image in user profile
        let user = PFUser.current()!
        let avaData = UIImageJPEGRepresentation(pp.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        user.username = usernameTxt.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        
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
    
    // hide keyboard func
    @objc func hideKeyboard(_ recognizer : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
       perfomAction()
        
        return true
        
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
