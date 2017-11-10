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
import Firebase

class RequestLocationVC: UIViewController,CLLocationManagerDelegate {

    var user: User!

    var locationTxt = ""
    
    // MARK: - Location
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
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
        
        var location = String()
        location = self.locationTxt
        let newDate = dateFormatter().string(from: Date())
        
        updateUser(withValues: [kCURRENTUSERLOCATION: location, kUPDATEDAT: newDate], withBlock: { (success) in
            if success {
                ProgressHUD.dismiss()
                
                self.user = Auth.auth().currentUser
                self.view.endEditing(false)
                
                print("Elvis: Location is \(String(describing: location))")
                
                //Proceed to Home Screen
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            }
        })
    
    }
    
    
    func reachability() {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                let alertVC = UIAlertController(title: "Location Access is not enabled", message: "iHike  cannot work without using your geolocation. \n Please first enable location in Settings to proceed", preferredStyle: .actionSheet)
                alertVC.addAction(UIAlertAction(title: "Open Settings", style: .default) { value in
                    let path = UIApplicationOpenSettingsURLString
                    if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.openURL(settingsURL)
                    }
                })
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertVC, animated: true, completion: nil)
                
                print("No access")
                
                return
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return
            }
        } else {
            print("Location services are not enabled")
        }
        
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
                print(location)
            } else {
                
                if self.locationTxt == "location unavailable"{
            
                    
                print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    

}
