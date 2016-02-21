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
    tableView.rowHeight = 150//UITableViewAutomaticDimension
    
    TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
        self.tweets = tweets
      }, failure: { (error: NSError) -> () in
        print(error.localizedDescription)
    })
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
  
  // MARK: - Logout
  
  @IBAction func onLogoutButton(sender: AnyObject) {
    TwitterClient.sharedInstance.logout()
  }
}
