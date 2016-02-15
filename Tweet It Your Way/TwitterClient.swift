//
//  TwitterClient.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/14/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "ZWmjlmA5HgYkjjkL0MmklQULA"
let twitterConsumerSecret = "sDwYgejT2n6OVrhPGSjvZI2gPqSgdZfbSp0e3biEPwLmpy5P3u"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
  
  static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
  
//  class var sharedInstance {
//    struct Static {
//      static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
//    }
//    return Static.instance
//    
//  }

}
