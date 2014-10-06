//
//  Tweet.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/6/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import Foundation

class Tweet {
    var text: String
    
    init(tweetDictionary: NSDictionary) {
        self.text = tweetDictionary["text"] as String
    }
    
    class func parseJSONDataIntoTweets(rawJSONData : NSData) -> [Tweet]? {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetDictionary: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            tweets.sort{$1.text > $0.text}
            return tweets
        }
        return nil
    }
}