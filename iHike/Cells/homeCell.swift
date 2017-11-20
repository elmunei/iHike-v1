//
//  homeCell.swift
//  iHike
//
//  Created by Elvis Tapfumanei on 16/11/2017.
//  Copyright © 2017 Elmunei. All rights reserved.
//

import UIKit
import SDWebImage
import Parse


class homeCell: UITableViewCell {

    @IBOutlet weak var pp: UIImageView!
    @IBOutlet weak var fullnameTxt: UILabel!
    @IBOutlet weak var locationTxt: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionTxt: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var rankingImg: UIImageView!
    @IBOutlet weak var rankingStats: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
