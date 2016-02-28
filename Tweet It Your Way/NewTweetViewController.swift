//
//  NewTweetViewController.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/27/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
  
  @IBOutlet weak var tweetTextView: UITextView!
  var newTweetText: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tweetTextView.text = newTweetText ?? ""
    tweetTextView.becomeFirstResponder()
  }
  
  @IBAction func sendTweet(sender: AnyObject) {
    TwitterClient.sharedInstance.sendTweet(text: tweetTextView.text) { (tweet, error) -> () in
      self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
  }
}
