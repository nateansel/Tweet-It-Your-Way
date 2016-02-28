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
  
  var loginSuccess: (() -> ())?
  var loginFailure: ((NSError) -> ())?
  
  func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
    GET("1.1/statuses/home_timeline.json",
      parameters: nil,
      progress: nil,
      success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        if let response = response as? [NSDictionary] {
          print("Got some tweets!")
          let tweets = Tweet.tweetsWithArray(response)
          success(tweets)
        }
      }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        failure(error)
    }
  }
  
  func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
    GET("1.1/account/verify_credentials.json",
      parameters: nil,
      progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        if let userDictionary = response as? NSDictionary {
          let user = User(dict: userDictionary)
          success(user)
        }
      }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        failure(error)
    })
  }
  
  func login(success: () -> (), failure: (NSError) -> ()) {
    loginSuccess = success
    loginFailure = failure
    
    deauthorize()
    fetchRequestTokenWithPath("oauth/request_token",
      method: "GET",
      callbackURL: NSURL(string: "tweetyourway://oauth"),
      scope: nil,
      success: { (requestToken: BDBOAuth1Credential!) -> Void in
        let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
        UIApplication.sharedApplication().openURL(url!)
      }, failure: { (error: NSError!) -> Void in
        print(error.localizedDescription)
        self.loginFailure?(error)
    })
  }
  
  func logout() {
    User.currentUser = nil
    deauthorize()
    NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotificationString, object: nil)
  }
  
  func handleOpenUrl(url: NSURL) {
    fetchAccessTokenWithPath("oauth/access_token",
      method: "POST",
      requestToken: BDBOAuth1Credential(queryString: url.query),
      success: {(accessToken: BDBOAuth1Credential!) -> Void in
        self.currentAccount({ (user: User) -> () in
          User.currentUser = user
          self.loginSuccess?()
          }, failure: { (error: NSError) -> () in
            self.loginFailure?(error)
        })
      },
      failure: {(error: NSError!) -> Void in
        print(error.localizedDescription)
        self.loginFailure?(error)
    })
  }
  
  func retweetTweetWithID(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/retweet/\(id).json",
      parameters: nil,
      progress: nil,
      success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        let tweet = Tweet(dict: response as! NSDictionary)
        print("Retweeted tweet: ", tweet)
        completion(tweet: tweet, error: nil)
      },
      failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        completion(tweet: nil, error: error)
    })
  }
  
  func unretweetTweetWithID(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/unretweet/\(id).json",
      parameters: nil,
      progress: nil,
      success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        let tweet = Tweet(dict: response as! NSDictionary)
        print("Unretweeted tweet: \(tweet)")
        completion(tweet: tweet, error: nil)
      },
      failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        completion(tweet: nil, error: error)
    })
  }
  
  func likeTweetWithID(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/favorites/create.json?id=\(id)",
      parameters: nil,
      progress: nil,
      success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        let tweet = Tweet(dict: response as! NSDictionary)
        print("Liked tweet: ", tweet)
        completion(tweet: tweet, error: nil)
      },
      failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        completion(tweet: nil, error: error)
    })
  }
  
  func unlikeTweetWithID(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/favorites/destroy.json?id=\(id)",
      parameters: nil,
      progress: nil,
      success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        let tweet = Tweet(dict: response as! NSDictionary)
        print("Unliked tweet: ", tweet)
        completion(tweet: tweet, error: nil)
      },
      failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        completion(tweet: nil, error: error)
    })
  }
  
  func sendTweet(text text: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
    POST("1.1/statuses/update.json",
      parameters: ["status":text],
      progress: nil,
      success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
        let tweet = Tweet(dict: response as! NSDictionary)
        print("Sent tweet: ", tweet)
        completion(tweet: tweet, error: nil)
      },
      failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
        completion(tweet: nil, error: error)
    })
  }
}
