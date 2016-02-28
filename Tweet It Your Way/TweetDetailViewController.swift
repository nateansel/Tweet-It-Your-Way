//
//  TweetDetailViewController.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/22/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var fullNameLabel:    UILabel!
  @IBOutlet weak var screennameLabel:  UILabel!
  @IBOutlet weak var timeStampLabel:   UILabel!
  @IBOutlet weak var tweetTextView:    UITextView!
  
  var tweet: Tweet?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tweetTextView.text = nil
    profileImageView.layer.cornerRadius = 5
    
    
    if let tweet = tweet {
      if let user = tweet.user {
        if let urlString = user.highResProfileImageUrl, url = NSURL(string: urlString) {
          profileImageView.setImageWithURL(url)
        }
        fullNameLabel.text = user.name
        if let screenname = user.screenname {
          screennameLabel.text = "@\(screenname)"
        }
      }
      if let date = tweet.timeStamp {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm a"
        timeStampLabel.text = formatter.stringFromDate(date)
      }
      tweetTextView.text = tweet.text
    }
  }
  
  // MARK: Buttons
  
  @IBAction func retweetButtonPressed(sender: AnyObject) {
    tweet?.toggleRetweet({ (tweet: Tweet) -> () in
      self.tweet = tweet
    })
  }
  
  @IBAction func likeButtonPressed(sender: AnyObject) {
    tweet?.toggleLike({ (tweet: Tweet) -> () in
      self.tweet = tweet
    })
  }
  
  @IBAction func replyButtonPressed(sender: AnyObject) {
    
  }
}
