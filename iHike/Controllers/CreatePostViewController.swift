//
//  CreatePostViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import CoreData
import ProgressHUD
import NotificationBannerSwift
import Parse
import YPImagePicker
import GooglePlaces

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate , UINavigationControllerDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet var toolbar: UIView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.textField.becomeFirstResponder()
        self.countLbl.text = ""
        self.textField.delegate = self
        self.textField.inputAccessoryView = self.toolbar

        placesClient = GMSPlacesClient.shared()

        getCurrentPlace()
        
        // declare select image tap
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(CreatePostViewController.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addGestureRecognizer(avaTap)

        
    }
    
    func getCurrentPlace() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.locationLabel.text = "Unknown location"
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.locationLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: ". ")
                }
            }
        })
    }
    
    func photoPicker () {
        

        var config = YPImagePickerConfiguration()
        config.libraryTargetImageSize = .original
        config.usesFrontCamera = false
        config.onlySquareImages = true
        config.showsFilters = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "iHike"
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didSelectImage = { [unowned picker] img in
            // image picked
            print(img.size)
            self.selectedImageView.image = img
            self.textField.becomeFirstResponder()
            self.textField.inputAccessoryView = self.toolbar

           
            
            self.textField.enablesReturnKeyAutomatically = true

            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }

    
    // call picker to select image
    @objc func loadImg(_ recognizer:UITapGestureRecognizer) {
        print("Elvis: Image tapped")
        photoPicker ()
    }
    
    // MARK: - Interactions
    @IBAction func tapCancelButton(_ sender: UIBarButtonItem) {
        if textField.text?.count == 0 {
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            
        } else {
            
            if textField.text != "" {
                
                let alertController = UIAlertController(title: "", message: "Discard your entry?", preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) in
                    
                }
                
                let okAction = UIAlertAction(title: "OK", style: .destructive) { (alert: UIAlertAction!) in
                    self.textField.text = ""
                    self.locationLabel.text = ""
                    self.selectedImageView.image = UIImage(named: "bg")
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.textField.becomeFirstResponder()
        self.textField.inputAccessoryView = self.toolbar
//        getCurrentPlace()

    }
    
    
    @IBAction func tapLocationButton(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
   
    
    @IBAction func postTapped(_ sender: Any) {
        performAction()

    }
    
   
    
    // MARK: - Location
    
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        performAction()
        
        
        return true
    }
    
    
    // MARK: - Textfield Actions/Functions
    
    func performAction() {
        
        if locationLabel.text == "Unknown" && locationLabel.text == "" {
            
            let banner = StatusBarNotificationBanner(title: "Location is missing! Please try again", style: .danger)
            banner.show()
            textField.inputAccessoryView = toolbar
            
            ProgressHUD.dismiss()
            
            return
        }
        
        if selectedImageView.image == UIImage(named: "bg")  {
            let banner = StatusBarNotificationBanner(title: "Photo missing! Please try again", style: .danger)
            banner.show()
            textField.inputAccessoryView = toolbar
            
            ProgressHUD.dismiss()
            
            return
        }
        
        ProgressHUD.show("Posting...", interaction: false)

        var postText = ""
        if let text = textField.text{
            postText = text
        }
//
//        let postId = NSUUID().uuidString
//        let postDate = NSDate().timeIntervalSince1970 as NSNumber
//
//        if let image = self.selectedImageView.image {
//
//            if let imageData = UIImageJPEGRepresentation(image, CGFloat(0.35)){
//
//
//
//                self.postService.uploadImageToFirebase(postId: postId, imageData: imageData, completion: { (url) in
//
//                    let user = FUser.currentUser()
//
//                    let post = Post(_objectId: postId, _postcreatedtimestamp: postDate, _postupdatedtimestamp: postDate, _username: user!.username, _userpostimage: String(describing:url), _postdescription: postText, _postrank: "\(0)", _postdistance: "\(0)", _postlocation: self.locationLabel.text!)
//
//                    self.postService.savePostToDB(post: post, completed: {
//                        ProgressHUD.dismiss()
//
//
//
//                    })
//                            self.textField.text = ""
//        self.locationLabel.text = ""
//        self.selectedImageView.image = UIImage(named: "bg")
//        let initialViewController = UIStoryboard.initialViewController(for: .main)
//        self.view.window?.rootViewController = initialViewController
//        self.view.window?.makeKeyAndVisible()
//                })
//
//
//            }
//        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // limit to 30 characters
        let characterCountLimit = 30
        
        // We need to figure out how many characters would be in the string after the change happens
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if(newLength <= characterCountLimit){
            self.countLbl.text = "\(30 - newLength)"
            return true
        } else {
            return false
        }
    }
    
    


}

extension CreatePostViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.locationLabel.text = place.formattedAddress
//        print("Place name: \(place.name)")
//        print("Place address: \(String(describing: place.formattedAddress))")
        dismiss(animated: true, completion: nil)
        self.textField.becomeFirstResponder()

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
