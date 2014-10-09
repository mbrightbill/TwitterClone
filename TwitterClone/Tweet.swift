//
//  Tweet.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/6/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import Foundation
import UIKit

class Tweet {
    var text: String
    var userDictionary: NSDictionary
    var tweetImageURL : NSURL
    var tweetImage : UIImage
    let tweetAccountName : String
    var retweetCountInt : Int
    var retweetCountString : String
    var favoriteCountInt : Int
    var favoriteCountString : String
    
    init(twitterDictionary: NSDictionary) {
        
        self.text = twitterDictionary["text"] as String
        
        self.userDictionary = twitterDictionary["user"] as NSDictionary
        
        let tweetImageString = userDictionary["profile_image_url"] as String
        
        self.tweetAccountName = userDictionary["name"] as String
        
        self.tweetImageURL = NSURL(string: tweetImageString)
        
        self.tweetImage = UIImage(data: NSData(contentsOfURL: tweetImageURL))
        
        self.retweetCountInt = twitterDictionary["retweet_count"] as Int
        self.retweetCountString = String(retweetCountInt)
        
        self.favoriteCountInt = twitterDictionary["favorite_count"] as Int
        self.favoriteCountString = String(favoriteCountInt)
    }
    
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(twitterDictionary: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            tweets.sort{$1.text > $0.text}
            return tweets
        }
        return nil
    }
}