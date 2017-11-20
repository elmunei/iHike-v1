//
//  RequestLocationVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 10/26/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import CoreLocation
import ProgressHUD
import NotificationBannerSwift
import Parse

class RequestLocationVC: UIViewController,CLLocationManagerDelegate {


    var locationTxt = ""
    var status = ""
    // MARK: - Location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self


    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBOutlet var exploreBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Location Button
    
    @IBAction func requestLocationAccess(_ sender: UIButton) {
        
        accessBtn.isHidden = true
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            getLocation()

        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            getLocation()

        case .denied:
            
            
            print("not available")

        case .restricted:
            //nothing I can do
            break
            
        }
        
    }
    @IBOutlet weak var accessBtn: UIButton!
    
    @IBAction func exploreBtn(_ sender: Any) {
        
        self.reachability()
        self.checkStatus()
        
        if status == "Not Determined" && status == "Denied" && status == "Restricted"  {
            
            let alertVC = UIAlertController(title: "Location Access is not enabled", message: "iHike  cannot work without using your geolocation. \n Please first enable location in Settings to proceed", preferredStyle: .actionSheet)
            alertVC.addAction(UIAlertAction(title: "Open Settings", style: .default) { value in
                let path = UIApplicationOpenSettingsURLString
                if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.openURL(settingsURL)
                }
            })
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertVC, animated: true, completion: nil)
            
            return
            
        }
        
        // save username/image in user profile
        let user = PFUser.current()!
        user["location"] = locationTxt
        
        user.saveInBackground (block: { (success, error) -> Void in
            if success{
                ProgressHUD.dismiss()
                // hide keyboard
                self.view.endEditing(true)
                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                ProgressHUD.dismiss()
                
                print("Elvis: Location is \(String(describing: self.locationTxt))")
                
                                //Proceed to Home Screen
                                let initialViewController = UIStoryboard.initialViewController(for: .main)
                                self.view.window?.rootViewController = initialViewController
                                self.view.window?.makeKeyAndVisible()
                
                
                
                
            } else {
                
                // show alert message
                let banner = StatusBarNotificationBanner(title:  error!.localizedDescription, style: .danger)
                banner.show()
                
                
                
            }
            
        })
        
        
    
    }
    
    
    func reachability() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                print("No access")
                
                return
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return
            }
        } else {
            print("Location services are not enabled")
        }
        return
        
    }
    // MARK: Location Functions
    func getLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
        
        
    }
    
    // MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if let placemarksData = placemarks {
                let locationData = placemarksData[0]
                let city = locationData.locality!
                let country = locationData.country!
                
                let location = "\(city), \(country)"
                
                self.locationTxt = location
                self.exploreBtn.isHidden = false
                print(location)
            } else {
                
                if self.locationTxt == "location unavailable"{
            
                    
                print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    
    func checkStatus() {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.status = "Not Determined"
        }
        if status == .denied {
            self.status = "Denied"
        }
        if status == .restricted {
            self.status = "Restricted"
        }
        if status == .authorizedAlways {
            self.status = "Always Allowed"
        }
        if status == .authorizedWhenInUse {
            self.status = "When In Use Allowed"
        }
    }

}
