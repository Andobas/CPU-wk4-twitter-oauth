//
//  User.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/13/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        //Kind of like your post office
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    //So this will give me a global notion of a current user at any time:



    class var currentUser: User? {
        
        get {
        if _currentUser == nil {
        //logged out or just boot up
        let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        if data != nil {
        let dictionary: NSDictionary?
        do {
        try dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
        _currentUser = User(dictionary: dictionary!)
    } catch {
        print(error)
        }
        }
        }
        return _currentUser
        }
        
        set(user) {
            _currentUser = user
            //User need to implement NSCoding; but, JSON also serialized by default
            if let _ = _currentUser {
                var data: NSData?
                do {
                    try data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print(error)
                }
            } else {
                //Clear the currentUser data
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
        }
}




//    class var currentUser: User? {
//        get {
//            if _currentUser == nil {
//                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
//                if data != nil {
//                    //var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
//        
//                    _currentUser = User(dictionary: dictionary)
//                }
//        
//            }
//            return _currentUser
//        }
//        set(user) {
//            _currentUser = user
//            
//            if _currentUser != nil {
//                //var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
//                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
//            } else {
//                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
//            }
//            NSUserDefaults.standardUserDefaults().synchronize()
//        }
//        
//    }
//    
}
