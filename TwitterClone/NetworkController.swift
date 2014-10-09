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
    
    var twitterAccount : ACAccount?
    
    init() {}
    
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
                        // right here, we are on a background queue aka thread
                    case 400...499:
                        println("this is the clients fault")
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
    
}