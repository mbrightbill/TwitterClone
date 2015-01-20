//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/6/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit
import Accounts
// social is for SLRequest
import Social

class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UIApplicationDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets : [Tweet]?
    
    var twitterAccount : ACAccount?
    
    var networkController : NetworkController!
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.networkController.fetchHometimeLine { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println(errorDescription?.debugDescription)
            } else {
                self.tweets = tweets
                
                self.tableView.reloadData()
            }
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        tableView.estimatedRowHeight = 71.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func refresh() {
        self.networkController.fetchHometimeLine { (errorDescription : String?, tweets : [Tweet]?) -> (Void) in
            if errorDescription != nil {
                println(errorDescription?.debugDescription)
            } else {
                self.tweets = tweets
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = self.tweets?[indexPath.row]
        
        if tweet?.tweetImage != nil {
            cell.tweetCellImageView.image = tweet?.tweetImage
        } else {
            self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                cellForImage?.tweetCellImageView.image = image
            })
        }

        cell.tweetCellLabel?.text = tweet?.text
    
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let singleTweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("singleTweetVC") as SingleTweetViewController
        singleTweetVC.selectedTweet = tweets?[indexPath.row]
        self.navigationController?.pushViewController(singleTweetVC, animated: true)
    }

}
