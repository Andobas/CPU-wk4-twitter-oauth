//
//  TweetCell.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/13/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = "\((tweet.user?.name)!)"
            handleLabel.text = "@" + "\((tweet.user?.screenname)!)"
            tweetLabel.text = tweet.text
            timeLabel.text = "\(tweet.createdAt!)"
            
            
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
