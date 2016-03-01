//
//  ProfileViewController.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/27/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetsTotalLabel: UILabel!
    @IBOutlet weak var followingTotalLabel: UILabel!
    @IBOutlet weak var followersTotalLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = (user?.profileImageUrl!)!
        profilePictureImageView.setImageWithURL(NSURL(string: imageUrl)!)
        
        //let banner = (user?.bannerImageUrl!)!
        bannerImageView.setImageWithURL((user?.bannerImageUrl!)!)
        
        nameLabel.text = user?.name
        handleLabel.text = "@\((user?.screenname)!)"
        tweetsTotalLabel.text = String(user!.statusesCount)
        followingTotalLabel.text = String(user!.followingTotal)
        followersTotalLabel.text = String(user!.followersTotal)
        
        
    
        
        

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
