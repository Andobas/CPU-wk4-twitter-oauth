//
//  ViewController.swift
//  twitter-oauth-demo
//
//  Created by mny on 2/7/16.
//  Modified by Juan Hernandez 02/09/2016
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
                //perform segue
                
                //If I did log in, then go ahead and take me to the  ¿home time iu view? Otherwise, display an error.
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                //handle login error
            }
        }
        
        //I don't want to have this level of transparency or understanding of the twitter client:
        /*
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
            }
            */

    }

    //"So now, as you can see, my login view controller is super-lean"

}

