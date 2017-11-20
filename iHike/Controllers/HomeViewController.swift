//
//  HomeViewController.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 07/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
 
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    

    var avatarImage: UIImage?
    
    var imageURLs = [String]()
    var descp = [String]()
    var location = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageURLs = ["https://images.unsplash.com/photo-1476610182048-b716b8518aae?auto=format&fit=crop&w=1427&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D", "https://images.unsplash.com/photo-1440755130913-8711f8195bdf?auto=format&fit=crop&w=1470&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D", "https://images.unsplash.com/photo-1494625927555-6ec4433b1571?auto=format&fit=crop&w=1353&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D", "https://images.unsplash.com/photo-1439853949127-fa647821eba0?auto=format&fit=crop&w=668&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D", "https://images.unsplash.com/photo-1504217051514-96afa06398be?auto=format&fit=crop&w=668&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D", "https://images.unsplash.com/photo-1445966275305-9806327ea2b5?auto=format&fit=crop&w=1350&q=60&ixid=dW5zcGxhc2guY29tOzs7Ozs%3D"]
        
        descp = ["Amazing Waterfalls, ⛰", "By the country side", "High Peaks", "Deep and Serene", "Sundowners in Europe", "On the road hiking"]
        
        location = ["London, United Kingdom", "Dubai, United Arab Emirates", "Harare, Zimbabwe", "New Orleans, United States", "Cairo, Egypt", "Hong Kong, Japan"]
    }
    
    
    
    // MARK: - Navigation
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return imageURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! homeCell
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.sd_setImage(with: URL(string: imageURLs[indexPath.row]))
        cell.descriptionTxt.text = descp[indexPath.row]
        cell.locationTxt.text = location[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "segueToPostView"{
//
//            let postViewController = segue.destination as! PostVC
//            let cell = sender as! UITableViewCell
//
//            postViewController.selectedIndexPath = tableview?.indexPath(for: cell)
//
//        }
    }
    
}

