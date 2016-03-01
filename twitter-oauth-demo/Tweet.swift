//
//  Tweet.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/13/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    //for favorites and retweets
    var id: String
    var retweetCount: Int?
    var likeCount: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        id = String (dictionary["id"]!)
        retweetCount = dictionary["retweet_count"] as? Int
        likeCount = dictionary["favorite_count"] as? Int
        
        
    }
    
    class func tweetsWithArray (array: [NSDictionary]) -> [Tweet] {
        //Simple convenience method that parses an array of tweets:
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
}
