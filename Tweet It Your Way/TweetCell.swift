//
//  TweetCell.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/20/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timeStampLabel: UILabel!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var likeButton: UIButton!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var likeCountLabel: UILabel!
  
  var tweet: Tweet? {
    didSet {
      if let tweet = tweet {
        if let user = tweet.user {
          profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
          usernameLabel.text = user.name
        }
        retweetCountLabel.text = "\(tweet.retweetCount)"
        likeCountLabel.text = "\(tweet.likeCount)"
        tweetTextLabel.text = tweet.text
        if let date = tweet.timeStamp {
          let formatter = NSDateFormatter()
          formatter.dateFormat = "MM/dd/yyyy hh:mm a"
          timeStampLabel.text = formatter.stringFromDate(date)
        }
        self.layoutSubviews()
      }
    }
  }
  
  @IBAction func retweetButtonPressed(sender: AnyObject) {
    if let id = tweet?.id {
      TwitterClient.sharedInstance.retweetTweetWithID(id) { (tweet, error) -> () in
        self.retweetButton.imageView?.image = UIImage(named: "retweetActive")
      }
    }
    if let tweet = tweet {
      tweet.retweetCount += 1
      self.retweetCountLabel.text = "\(tweet.retweetCount)"
    }
  }
  
  @IBAction func likeButtonPressed(sender: AnyObject) {
    if let id = tweet?.id {
      TwitterClient.sharedInstance.favoriteTweetWithID(id) { (tweet, error) -> () in
        self.likeButton.imageView?.image = UIImage(named: "likeActive")
      }
    }
    if let tweet = tweet {
      tweet.likeCount += 1
      self.likeCountLabel.text = "\(tweet.likeCount)"
    }
  }
}
