//
//  DetailsViewController.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/24/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeAndDateLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(tweet)")
        nameLabel.text = "\((tweet.user?.name)!)"
        handleLabel.text = "\((tweet.user?.screenname)!)"
        tweetLabel.text = tweet.text
        
        
        //Retrieving the image
        let imageUrl = tweet.user?.profileImageUrl!
        profilePictureImageView.setImageWithURL(NSURL(string: imageUrl!)!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
