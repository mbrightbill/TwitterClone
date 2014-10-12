//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Matthew Brightbill on 10/8/14.
//  Copyright (c) 2014 Matthew Brightbill. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
    
    var twitterAccount : ACAccount!
    let imageQueue = NSOperationQueue()
    
    init() {
        self.imageQueue.maxConcurrentOperationCount = 6
    }
    
    func fetchHometimeLine( completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
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
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(tweets?.count)
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        // below, we are on a background queue aka thread
                    case 400...499:
                        println("this is the clients fault")
                        println(httpResponse.statusCode)
                        completionHandler(errorDescription: "This is your fault", tweets: nil)
                    case 500...599:
                        println("this is the servers fault")
                        completionHandler(errorDescription: "Server's fault", tweets: nil)
                    default:
                        println("Something bad happened")
                    }
                })
            }
        }
        
    }
    
    func fetchUserTimeLine( userScreenName : String?, completionHandler : (errorDescription : String?, tweet : [Tweet]?) -> (Void)) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted {
                println(userScreenName)
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(userScreenName!)")
                println(userScreenName)
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    println(httpResponse)
                    switch httpResponse.statusCode {
                    case 200...299:
                        let tweet = Tweet.parseJSONDataIntoTweets(data)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, tweet: tweet)
                        })
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
    }
    
    func downloadUserImageForTweet(tweet : Tweet, completionHandler : (image : UIImage) -> (Void)) {
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            let url = NSURL(string: tweet.tweetImageString)
            let imageData = NSData(contentsOfURL: url) // network call
            var avatarImage = UIImage(data: imageData)
            tweet.tweetImage = avatarImage
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image: avatarImage)
            })
        }
        
    }
    
}