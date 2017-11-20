//
//  InterestsVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 10/27/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD
import NotificationBannerSwift

class InterestsVC: UIViewController {

   

    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var trekker: ETRadioButton!
    @IBOutlet weak var biker: ETRadioButton!
    @IBOutlet weak var walker: ETRadioButton!
    @IBOutlet weak var runner: ETRadioButton!
    
    
    
    
    
    
    var interest1 = ""
    var interest2 = ""
    var interest3 = ""
    var interest4 = ""

    var userInterests: [String] = []
    
     // MARK: - Outlets
    
    
    @IBAction func trekkerBtn(_ sender: ETRadioButton) {
   
        sender.isSelected = !sender.isSelected
        
        if (sender as AnyObject).isSelected {
            interest1 = "Trekker"
            nextBtn.title = "Next"
        } else{
            interest1 = ""
            nextBtn.title = "Skip"

        }
        
        print(interest1)
    }
    
    @IBAction func bikerBtn(_ sender: ETRadioButton) {
    
        sender.isSelected = !sender.isSelected
        
        if (sender as AnyObject).isSelected {
            interest2 = "Biker"
            nextBtn.title = "Next"

            
        } else{
            interest2 = ""
            nextBtn.title = "Skip"

        }
        
        print(interest2)

    }
    
    
    @IBAction func walkerBtn(_ sender: ETRadioButton) {
   
        sender.isSelected = !sender.isSelected
        
        if (sender as AnyObject).isSelected {
            interest3 = "Walker"
            nextBtn.title = "Next"

        } else{
            interest3 = ""
            nextBtn.title = "Skip"

        }
        
        print(interest3)

    }
    @IBAction func runnerBtn(_ sender: ETRadioButton) {
    
        sender.isSelected = !sender.isSelected
        
        if (sender as AnyObject).isSelected {
            interest4 = "Runner"
            nextBtn.title = "Next"

        } else{
            interest4 = ""
            nextBtn.title = "Skip"

        }
        
        print(interest4)

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Elvis: You are on Interests screen")
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    // MARK: - Navigation

    @IBAction func NextBtn(_ sender: Any) {
        
        ProgressHUD.show("please wait...")
        
        if trekker.isSelected == false && biker.isSelected == false && runner.isSelected == false && walker.isSelected == false {
            let banner = StatusBarNotificationBanner(title: "Select at least one interest", style: .warning)
            banner.show()
            
            
            ProgressHUD.dismiss()
            
            return
        }
        
        userInterests.append(interest1)
        userInterests.append(interest2)
        userInterests.append(interest3)
        userInterests.append(interest4)
        
        
        
        // save username/image in user profile
        let user = PFUser.current()!
        user["interests"] = userInterests
        
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
                self.performSegue(withIdentifier: Constants.Segue.toAddLocation, sender: self)
                
                
                
                
            } else {
                
                // show alert message
                let banner = StatusBarNotificationBanner(title:  error!.localizedDescription, style: .danger)
                banner.show()
                
                
                
            }
            
        })
        


    }
    
 
    

}
