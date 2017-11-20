//
//  PostVC.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 16/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indexPath = selectedIndexPath{
            postImg.image = UIImage(named: "")
        }
    }
    
    // MARK: - Properties
    
    var selectedIndexPath: IndexPath?
    
    
    // MARK: - Outlets
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var commentsLbl: UILabel!
    @IBOutlet weak var postDescriptionLbl: UILabel!
}
