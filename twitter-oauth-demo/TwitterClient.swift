//
//  TwitterClient.swift
//  twitter-oauth-demo
//
//  Created by mny on 2/7/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "E9Mwop8b4Q3XOcfuHe87rAZi1"
let twitterConsumerSecret = "3FoRTPIWoXyzBSv8vIYJDZCRQ1xr5p4fP4pmDn2Akb3GI95m5G"

class TwitterClient: BDBOAuth1SessionManager {
    
    //I want to store a variable that may or may not be there, so we'll just make it optional:
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseUrl,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json",
            parameters: params,
            success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("home_timeline: \(response!)")
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
        },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
             print("error getting home timeline")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Here I can begin to initiate...the twitter login dance:
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "cputwitterJuan://oauth"),
            scope: nil,
            success: {
                (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                
                UIApplication.sharedApplication().openURL(authURL!)
                
        }) {
                (error: NSError!) -> Void in
            print("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        
        //Says: ok, let me just do the final step, which is to get the access token:
        
        //So now, in fetchAccessTokenWithPath, I get the access token, and then I get the account credentials, and then get my current user.
        fetchAccessTokenWithPath(
            "oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got the access token!")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET(
                    "1.1/account/verify_credentials.json",
                    parameters: nil,
                    success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        //print("user: \(response!)")
                        
                        //Here's me logging in:
                        var user = User(dictionary: response as! NSDictionary)
                        //So once I successfully deserialize this, if I say:
                        User.currentUser = user
                        //that should persist this user as the current user. And then, henceforth in this project, currentUser will always be available to access the currently logged in user.
                        
                        print("user: \(user.name)")
                        //So at this point I have a user, and I should be able to call:
                        self.loginCompletion?(user: user, error: nil)
                },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
                        
                })
            },
            failure: { (error: NSError!) -> Void in
            print("Failed to receive access token")
            self.loginCompletion?(user: nil, error: error)
        })
    }
    
    func getUserBanner(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        GET("1.1/users/profile_banner.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("got user banner")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("did not get user banner")
                completion(error: error)
            }
        )
    }
    
    //****************************************
    func userTweets(profileScreenName: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweets: \(response)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't find the tweets")
                completion(error: error)
            }
        )
    }
    
    func reply(escapedTweet: String, statusID: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json?in_reply_to_status_id=\(statusID)&status=\(escapedTweet)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't reply")
                completion(error: error)
            }
        )
    }
    
    
    func compose(escapedTweet: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json?status=\(escapedTweet)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("tweeted: \(escapedTweet)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't compose")
                completion(error: error)
            }
        )
    }

    
    
    
    func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Retweeted tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't retweet")
                completion(error: error)
            }
        )
    }
    
    func likeTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("Liked tweet with id: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't like tweet")
                completion(error: error)
            }
        )}
    
    
}
