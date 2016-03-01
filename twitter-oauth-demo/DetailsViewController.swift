//
//  DetailsViewController.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/24/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //let detailsViewController = DetailsViewController!.self
    
    /*
    var tweetCell: TweetCell!
    */
    
    var tweetID: String = ""
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tweetID = tweet.id
        //print("tweetID now = \(tweetID)")
        
        print("\(tweet)")
        nameLabel.text = "\((tweet.user?.name)!)"
        //nameLabel.text = tweet.user!.name
        
        handleLabel.text = "\((tweet.user?.screenname)!)"
        tweetLabel.text = tweet.text
        timeLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
        
        
        
        //Retrieving the image
        let imageUrl = tweet.user?.profileImageUrl!
        profilePictureImageView.setImageWithURL(NSURL(string: imageUrl!)!)
        
        
        tweetID = tweet.id
        retweetLabel.text = String(tweet.retweetCount!)
        favoriteLabel.text = String(tweet.likeCount!)
        
        retweetLabel.text! == "0" ? (retweetLabel.hidden = true) : (retweetLabel.hidden = false)
        favoriteLabel.text! == "0" ? (favoriteLabel.hidden = true) : (favoriteLabel.hidden = false)
        
        
        //For time?
        /*
        var formatter = NSDateFormatter()
        timeAndDateLabel.dateFormat = "EEE MMM d HH:mm:ss Z y"
        */

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        // Turn timeTweetPostedAgo into seconds, minutes, hours, days, or years
        var rawTime = Int(timeTweetPostedAgo)
        var timeAgo: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        // Figure out time ago
        if (rawTime <= 60) { // SECONDS
            timeAgo = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) { // MINUTES
            timeAgo = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) { // HOURS
            timeAgo = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) { // DAYS
            timeAgo = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) { // YEARS
            timeAgo = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(timeAgo)\(timeChar)"
    }
    
    
        
    @IBAction func onLike(sender: AnyObject) {
    
        TwitterClient.sharedInstance.likeTweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Selected)
            
            if self.favoriteLabel.text! > "0" {
                self.favoriteLabel.text = String(self.tweet.likeCount! + 1)
            } else {
                self.favoriteLabel.hidden = false
                self.favoriteLabel.text = String(self.tweet.likeCount! + 1)
            }
        })
    }
    
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Selected)
            
            if self.retweetLabel.text! > "0" {
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.retweetLabel.hidden = false
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            }
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier) == "SegueToReply" {
            let user = User.currentUser
            let tweet = self.tweet
            
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.user = user
            composeViewController.tweet = tweet
            composeViewController.userNameHandleText = (user?.screenname)!
            composeViewController.isReply = true
        } else {
            
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
