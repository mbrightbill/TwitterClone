//
//  UserTimeLineViewController.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/9/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit
import Accounts
import Social

class UserTimeLineViewController: UIViewController, UITableViewDataSource, UIApplicationDelegate, UITableViewDelegate {

    var networkController : NetworkController!
    
    var refreshControl : UIRefreshControl!
    
    var tweets : [Tweet]?
    
    @IBOutlet weak var userTimeLineTableView: UITableView!
    
    var selectedTweet2 : Tweet?
    var userScreenName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTimeLineTableView.dataSource = self
        self.userTimeLineTableView.delegate = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController
        
        self.userScreenName = selectedTweet2?.userScreenName
        
        self.userTimeLineTableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        self.networkController.fetchUserTimeLine(self.userScreenName) { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println("FETCH ERROR.")
                println(errorDescription?.debugDescription)
            } else {
                self.tweets = tweets
                println("fetch complete, time to reload")
                self.userTimeLineTableView.reloadData()
            }
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.blueColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.userTimeLineTableView.addSubview(refreshControl)
        
        userTimeLineTableView.estimatedRowHeight = 71.0
        userTimeLineTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func refresh() {
        self.networkController.fetchUserTimeLine(self.userScreenName) { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println(errorDescription?.debugDescription)
            } else {
                self.tweets = tweets
                
                self.userTimeLineTableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            println(self.tweets!.count)
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = userTimeLineTableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        let tweet = self.tweets?[indexPath.row]
        
        if tweet?.tweetImage != nil {
            cell.tweetCellImageView.image = tweet?.tweetImage
            //cell.tableViewCellImageView.image = tweet?.tweetImage
        } else {
            self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
                let cellForImage = self.userTimeLineTableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                cellForImage?.tweetCellImageView.image = image
                //cellForImage?.tableViewCellImageView.image = image
            })
        }
        cell.tweetCellLabel?.text = tweet?.text
        //cell.cellTextLabel?.text = tweet?.text
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        userTimeLineTableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let singleTweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("singleTweetVC") as SingleTweetViewController
        singleTweetVC.selectedTweet = tweets?[indexPath.row]
        self.navigationController?.pushViewController(singleTweetVC, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
