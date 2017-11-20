//
//  AppDelegate.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import CoreLocation
import Parse
import NotificationCenter
import FBSDKCoreKit
import UserNotifications
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import Parse
import ProgressHUD
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Google Places
        GMSPlacesClient.provideAPIKey("AIzaSyCrzYPqCDvit7DFbL8TvEtBS72FMast4NI")
        GMSServices.provideAPIKey("AIzaSyCrzYPqCDvit7DFbL8TvEtBS72FMast4NI")
        
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Enable Local Datastore.
        Parse.enableLocalDatastore()
        
        

        // Initialize Parse.
        
        let parseConfig = ParseClientConfiguration {(ParseMutableClientConfiguration)  in
            
            
            //Accessing pikicha via id & keys
            ParseMutableClientConfiguration.applicationId = "HtsKA78vlD9ElqsSeuZwvYG92V35KAuqfN0frJDL"
            ParseMutableClientConfiguration.clientKey = "GNCWe7gUjtVs10Zf2VDXmLwB1nFSGDKVPbY5mm8C"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            ParseMutableClientConfiguration.isLocalDatastoreEnabled = true
            
            
        }
        
        Parse.initialize(with: parseConfig)
        
        
        // Track statistics on application openings.
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
        //Facebook
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        // call login function
        login()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Facebook
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    //MARK: Facebook login
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let result = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return result
    }
    
    
    func login() {
        
        // remember user's login
        let username : String? = UserDefaults.standard.string(forKey: "username")
        
        // if logged in
        let initialViewController: UIViewController
        
        if username != nil {
            
            ProgressHUD.dismiss()
            
            initialViewController = UIStoryboard.initialViewController(for: .main)
        } else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }
        
    
    
    
}

extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults : String? = UserDefaults.standard.string(forKey: "username")
        let initialViewController: UIViewController
        
        if defaults != nil {
            initialViewController = UIStoryboard.initialViewController(for: .main)
        } else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
