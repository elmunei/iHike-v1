//
//  NearbyViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 16/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NearbyViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var userMap: MKMapView!
    var locationManager:CLLocationManager!
    let annotation = MKPointAnnotation()
    
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tm()
       
        
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
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
            return
    }
        
    }
    
    
    
    func tm() {
        annotation.coordinate = CLLocationCoordinate2D(latitude: 33.9628, longitude: 18.4098)
        userMap.addAnnotation(annotation)
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }

    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        userMap.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        userMap.addAnnotation(myAnnotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
          print("Error \(error)")
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
