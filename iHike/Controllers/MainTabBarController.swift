//
//  MainTabBarControllerViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Properties
    
    let photoHelper = IHPhotoHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoHelper.completionHandler = { image in
            print("handle image")
        }

        delegate = self
        tabBar.unselectedItemTintColor = UIColor(red: 253/255, green: 93/255, blue: 93/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            // present photo taking action sheet

            print("take photo")
            
            return false
        }
            return true
    }
    
}
