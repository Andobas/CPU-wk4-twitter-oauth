//
//  TweetCell.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/13/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweetID: String = ""
    
    @IBOutlet weak var profileThumbButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = "\((tweet.user?.name)!)"
            handleLabel.text = "@" + "\((tweet.user?.screenname)!)"
            tweetLabel.text = tweet.text
            //timeLabel.text = "\(tweet.createdAt!)"
            timeLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
            
            
            //Retrieving the image
            let imageUrl = tweet.user?.profileImageUrl!
            profilePictureImageView.setImageWithURL(NSURL(string: imageUrl!)!)
        
            tweetID = tweet.id
            retweetLabel.text = String(tweet.retweetCount!)
            favoriteLabel.text = String(tweet.likeCount!)
            
            retweetLabel.text! == "0" ? (retweetLabel.hidden = true) : (retweetLabel.hidden = false)
            favoriteLabel.text! == "0" ? (favoriteLabel.hidden = true) : (favoriteLabel.hidden = false)
            
            
        }
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Give rounded edges to profile picture
        profilePictureImageView.layer.cornerRadius = 3
        profilePictureImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(Int(tweetID)!, params: nil, completion: {(error) -> () in
            self.retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: UIControlState.Selected)
            
            if self.retweetLabel.text! > "0" {
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            } else {
                self.retweetLabel.hidden = false
                self.retweetLabel.text = String(self.tweet.retweetCount! + 1)
            }
        })
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
    
    
}
