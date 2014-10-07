//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/6/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import UIKit

class HomeTimeLineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets : [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
            var error : NSError?
            let jsonData = NSData(contentsOfFile: path)
            
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
            
            println(tweets?.count)
        }
        
        self.tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
        let tweet = self.tweets?[indexPath.row]
        cell.textLabel?.text = tweet?.text
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
