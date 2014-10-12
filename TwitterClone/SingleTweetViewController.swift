//
//  SingleTweetViewController.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/8/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {

    @IBOutlet weak var tweetBody: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var selectedTweet : Tweet!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.selectedTweet != nil {
            self.userImage.image = self.selectedTweet.tweetImage
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tweetBody.text = selectedTweet.text
        self.userNameLabel.text = selectedTweet.tweetAccountName
        self.retweetCountLabel.text = selectedTweet.retweetCountString
        self.favoritesCountLabel.text = selectedTweet.favoriteCountString
    }
    
    @IBAction func photoButtonPressed(sender: AnyObject) {
        let userTimeLineVCConstant = self.storyboard?.instantiateViewControllerWithIdentifier("userTimeLineVC") as UserTimeLineViewController
        userTimeLineVCConstant.selectedTweet2 = self.selectedTweet
        self.navigationController?.pushViewController(userTimeLineVCConstant, animated: true)
                
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
