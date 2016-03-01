//
//  ComposeViewController.swift
//  twitter-oauth-demo
//
//  Created by Juan Hernandez on 2/27/16.
//  Copyright © 2016 ccsf. All rights reserved.
//

import UIKit


class ComposeViewController: UIViewController, UITextViewDelegate {

    var user: User?
    var tweet: Tweet?
    var userNameHandleText: String?
    var tweetContent: String = ""
    var isReply: Bool?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var composeTweetView: UITextView!
    @IBOutlet weak var characterLimit: UILabel!
  
    @IBOutlet weak var sendTweetButton: UIBarButtonItem!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        composeTweetView.delegate = self
        handleLabel.text = "@\(User.currentUser!.screenname!)"
        nameLabel.text = User.currentUser!.name!
        profilePictureImageView.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!)!)
        
        
        placeHolderLabel.text = ""
        composeTweetView.addSubview(placeHolderLabel)
        placeHolderLabel.hidden = !composeTweetView.text.isEmpty
        
        
        composeTweetView.becomeFirstResponder()
        
        
        if (isReply) == true {
            composeTweetView.text = "@\((tweet?.user?.screenname)!)"
            if  0 < (141 - composeTweetView.text!.characters.count) {
                sendTweetButton.enabled = true
                characterLimit.text = "\(140 - composeTweetView.text!.characters.count)"
            }
            else{
                sendTweetButton.enabled = false
            }
            isReply = false
        }
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func dismiss(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {});//This is intended to dismiss the Info sceen.
        print("pressed")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTweet(sender: AnyObject) {
        
        tweetContent = composeTweetView.text
        
        let escapedTweetMessage = tweetContent.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        
        if isReply == true {
            TwitterClient.sharedInstance.reply(escapedTweetMessage!, statusID: Int(tweet!.id)!, params: nil, completion: { (error) -> () in
                print("replying")
                
            })
            
            isReply = false
            navigationController?.popViewControllerAnimated(true)
        } else {
            TwitterClient.sharedInstance.compose(escapedTweetMessage!, params: nil, completion: { (error) -> () in
                print("composing")
            })
            navigationController?.popViewControllerAnimated(true)
        }
        
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        placeHolderLabel.hidden = !composeTweetView.text.isEmpty
        if  0 < (141 - composeTweetView.text!.characters.count) {
            sendTweetButton.enabled = true
            characterLimit.text = "\(140 - composeTweetView.text!.characters.count)"
            
        }
        else{
            sendTweetButton.enabled = false
            characterLimit.text = "\(140 - composeTweetView.text!.characters.count)"
            
            
        }
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
