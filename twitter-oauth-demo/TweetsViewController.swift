//
//  TweetsViewController.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/13/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit
//import BDBOAuth1Manager
//import AFNetworking


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        apiNetworkRequest()
        
        // Initialize a UIRefreshControl
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func apiNetworkRequest () {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        //cell.buttonDelegate = self
        cell.tweet = tweets![indexPath.row]
        
//I MIGHT NOT NEED THIS ANYMORE WITH THE DELEGATE
        /*
        cell.profileThumbButton.addTarget(self, action: "thumbClicked", forControlEvents: .TouchUpInside)
        */
        
        return cell
    }

//I MIGHT NOT NEED THIS ANYMORE EITHER W/THE DELEGATE
    /*
    func thumbClicked() {
        self.performSegueWithIdentifier("profileSegue", sender: self)
    }
    */
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion:  { (tweets, error) -> () in
            //self.tweets = tweets
        
        apiNetworkRequest()
        
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    
    /*
        let twitterConsumerKey = "E9Mwop8b4Q3XOcfuHe87rAZi1"
        let twitterConsumerSecret = "3FoRTPIWoXyzBSv8vIYJDZCRQ1xr5p4fP4pmDn2Akb3GI95m5G"
        let twitterBaseURL = NSURL(string: "https://api.twitter.com")
        let request = NSURLRequest(URL: twitterBaseURL!)
        
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                
                // Tell the refreshControl to stop spinning
                refreshControl.endRefreshing()
        });
        task.resume()
        
    }
    */
    
    
    //...it'll fire a global notification that the user logged out...
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "SegueToDetails") {
            let cell = sender as! UITableViewCell
            let indexpath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexpath!.row]
        
            let tweetDetailViewController = segue.destinationViewController as! DetailsViewController
        tweetDetailViewController.tweet = tweet
        }
        
        else if (segue.identifier) == "SegueToCompose" {
            
            let user = User.currentUser
            
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.user = user
        }
            
            
        else if (segue.identifier) == "SegueToProfile" {
            
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let user = tweet.user
            
            let profileViewController = segue.destinationViewController as? ProfileViewController
            profileViewController?.user = user
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
