//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/10/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetCellLabel: UILabel!
    
    @IBOutlet weak var tweetCellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
