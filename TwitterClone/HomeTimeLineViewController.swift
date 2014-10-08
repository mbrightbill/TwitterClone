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

class HomeTimeLineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var tweets : [Tweet]?
    
    var twitterAccount : ACAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        // asynchronous call -- not on main thread
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                // setup our twitter request
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    switch httpResponse.statusCode {
                    case 200...299:
                        self.tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(self.tweets?.count)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                             self.tableView.reloadData()
                        })
                        // right here, we are on a background queue aka thread
                    case 400...499:
                        println("this is the clients fault")
                    case 500...599:
                        println("this is the servers fault")
                    default:
                        println("Something bad happened")
                    }
                })
            }
        }
        
//        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//            var error : NSError?
//            let jsonData = NSData(contentsOfFile: path)
//            
//            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
//            
//            println(tweets?.count)
//        }
        
    
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
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
