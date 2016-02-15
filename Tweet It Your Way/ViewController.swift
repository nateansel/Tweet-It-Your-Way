//
//  ViewController.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/14/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  @IBAction func loginButtonClicked(sender: AnyObject) {
    TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
    TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
      method: "GET",
      callbackURL: NSURL(string: "tweetyourway://oauth"),
      scope: nil,
      success: {(request: BDBOAuth1Credential!) -> Void in
        print("Got the request token!")
        let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request.token)")
        UIApplication.sharedApplication().openURL(authURL!)
      },
      failure: {(error: NSError!) -> Void in
        print("Failed to get request token.")
//        self.loginCompletion?(user: nil, error: error)
    })
  }

}

