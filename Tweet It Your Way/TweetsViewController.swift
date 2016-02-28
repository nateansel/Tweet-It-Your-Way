//
//  TweetsViewController.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/20/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  var tweets: [Tweet]? {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 150
    
    TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
        self.tweets = tweets
      }, failure: { (error: NSError) -> () in
        print(error.localizedDescription)
    })
  }
  
  override func viewWillAppear(animated: Bool) {
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  }
  
  // MARK: - Table View Data Source
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }
  
  // MARK: - Table View Delegate
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as? TweetCell
    cell?.tweet = tweets?[indexPath.row]
    return cell!
  }
  
  // MARK: - Animation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "TweetDetailSegue" {
      if let destinationViewController = segue.destinationViewController as? TweetDetailViewController {
        if let cell = sender as? TweetCell {
          destinationViewController.tweet = cell.tweet
        }
      }
    }
    else if segue.identifier == "toProfileView" {
      if let destinationViewController = segue.destinationViewController as? ProfileDetailViewController {
        let cell = (sender as? UIGestureRecognizer)?.view?.superview?.superview as? TweetCell
        if let cell = cell {
          destinationViewController.user = cell.tweet?.user
        }
      }
    }
    else if segue.identifier == "toReplyView" {
      if let dest = segue.destinationViewController as? UINavigationController {
        let tweet = (sender?.superview??.superview?.superview as? TweetCell)?.tweet
        (dest.topViewController as? NewTweetViewController)?.newTweetText = "@\(tweet?.user?.screenname ?? "") "
      }
    }
  }
  
  @IBAction func userImageTapped(sender: AnyObject) {
    performSegueWithIdentifier("toProfileView", sender: sender)
  }
  
  
  // MARK: - Logout
  
  @IBAction func onLogoutButton(sender: AnyObject) {
    TwitterClient.sharedInstance.logout()
  }
}
