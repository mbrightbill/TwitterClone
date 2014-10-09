//
//  HomeTimeLineTableViewCell.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/7/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit

class HomeTimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var tableViewCellImageView: UIImageView!
    
    @IBOutlet weak var cellTextLabel: UILabel!
    
    @IBOutlet weak var tweetCellUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
