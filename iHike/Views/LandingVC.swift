//
//  LandingVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 13/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LandingVC: UIViewController, PFLogInViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (PFUser.current() != nil) {
            // User is signed in. Show home screen
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            
            loginViewController.fields = .facebook
            } else {
            // No User is signed in. Show user the login screen
            print("Elvis: User is signed out")
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
