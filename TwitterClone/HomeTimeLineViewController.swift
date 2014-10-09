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

class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UIApplicationDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets : [Tweet]?
    
    var twitterAccount : ACAccount?
    
    var networkController : NetworkController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        tableView.estimatedRowHeight = 71.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.networkController.fetchHometimeLine { (errorDescription : String?, tweets : [Tweet]?) -> (Void) in
            if errorDescription != nil {
                
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as HomeTimeLineTableViewCell
        let tweet = self.tweets?[indexPath.row]
        cell.tableViewCellImageView.image = tweet?.tweetImage
        
        cell.cellTextLabel?.text = tweet?.text
        cell.tweetCellUserName.text = tweet?.tweetAccountName
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTweet" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            var singleTweetViewController = segue.destinationViewController as SingleTweetViewController
            singleTweetViewController.selectedTweet = tweets?[indexPath!.row]
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
