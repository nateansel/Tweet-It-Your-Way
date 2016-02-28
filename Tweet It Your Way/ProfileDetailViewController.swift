//
//  ProfileDetailViewController.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/27/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController {

  var user: User?
  
  @IBOutlet weak var headerImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var fullnameLabel: UILabel!
  @IBOutlet weak var screennameLabel: UILabel!
  @IBOutlet weak var numberOfTweetsLabel: UILabel!
  @IBOutlet weak var numberOfFollowingLabel: UILabel!
  @IBOutlet weak var numberOfFollowers: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    headerImageView.setImageWithURL(NSURL(string: user!.headerImageUrl!)!)
    profileImageView.setImageWithURL(NSURL(string: user!.highResProfileImageUrl!)!)
    fullnameLabel.text = user!.name
    screennameLabel.text = user!.screenname
    numberOfTweetsLabel.text = "Tweets: \(user!.tweetCount ?? 0)"
    numberOfFollowingLabel.text = "Following: \(user!.followingCount ?? 0)"
    numberOfFollowers.text = "Followers: \(user!.followersCount ?? 0)"
    
  }
  
}
