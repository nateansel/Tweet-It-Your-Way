//
//  TweetCell.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/20/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
  
  // MARK: - Properties
  
  @IBOutlet weak var usernameLabel:     UILabel!
  @IBOutlet weak var tweetTextLabel:    UILabel!
  @IBOutlet weak var timeStampLabel:    UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var likeCountLabel:    UILabel!
  @IBOutlet weak var screennameLabel:   UILabel!
  @IBOutlet weak var retweetButton:     UIButton!
  @IBOutlet weak var likeButton:        UIButton!
  @IBOutlet weak var replyButton:       UIButton!
  @IBOutlet weak var profileImageView:  UIImageView!
  
  var tweet: Tweet? {
    didSet {
      if let tweet = tweet {
        // Set the user information
        if let user = tweet.user {
          profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
          usernameLabel.text = user.name
          if let screenname = user.screenname {
            screennameLabel.text = "@\(screenname)"
          }
        }
        // Set the tweet infomation labels
        retweetCountLabel.text = "\(tweet.retweetCount)"
        likeCountLabel.text = "\(tweet.likeCount)"
        tweetTextLabel.text = tweet.text
        if let date = tweet.timeStamp {
          let formatter = NSDateFormatter()
          formatter.dateFormat = "hh:mm a"
          timeStampLabel.text = formatter.stringFromDate(date)
        }
        // Set the tweet buttons based on the tweet's like and retweet status
        if tweet.liked {
          likeButton.imageView?.image = UIImage(named: "likeActive")
        }
        if tweet.retweeted {
          retweetButton.imageView?.image = UIImage(named: "retweetActive")
        }
        // Layout the subviews so that the cell updates
        self.layoutSubviews()
      }
    }
  }
  
  // MARK: - Methods
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
  
  // MARK: Overrides
  
  override func awakeFromNib() {
    super.awakeFromNib()
    profileImageView.layer.cornerRadius  = 5
    profileImageView.layer.masksToBounds = true
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.image         = nil
    usernameLabel.text             = nil
    timeStampLabel.text            = nil
    tweetTextLabel.text            = nil
    retweetCountLabel.text         = nil
    likeCountLabel.text            = nil
    retweetButton.imageView?.image = UIImage(named: "retweetInactive")
    likeButton.imageView?.image    = UIImage(named: "likeInactive")
  }
}
