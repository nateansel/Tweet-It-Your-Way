//
//  Tweet.swift
//  Tweet It Your Way
//
//  Created by Nathan Ansel on 2/17/16.
//  Copyright © 2016 Nathan Ansel. All rights reserved.
//

import Foundation

class Tweet {
  
  var user:            User?
  var text:            String?
  var id:              String?
  var timeStamp:       NSDate?
  var retweetCount:    Int = 0
  var likeCount:       Int = 0
  var liked:           Bool = false
  var retweeted:       Bool = false
  
  init(dict: NSDictionary) {
    user         = User(dict: dict["user"] as? NSDictionary)
    text         = dict["text"] as? String
    id           = dict["id_str"] as? String
    retweetCount = dict["retweet_count"] as? Int ?? 0
    likeCount    = dict["favorite_count"] as? Int ?? 0
    liked        = dict["favorited"] as? Bool ?? false
    retweeted    = dict["retweeted"] as? Bool ?? false
  
    if let dateString = dict["created_at"] as? String {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timeStamp = formatter.dateFromString(dateString)
    }
  }
  
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
    var tweets = [Tweet]()
    for dict in dictionaries {
      let tweet = Tweet(dict: dict)
      tweets.append(tweet)
    }
    return tweets
  }
  
  func toggleLike(success: (Tweet) -> ()) {
    if liked {
      if let id = id {
        TwitterClient.sharedInstance.unlikeTweetWithID(id, completion: { (tweet, error) -> () in
          if let _ = tweet {
            self.liked = false
            self.likeCount -= 1
          }
        })
      }
    }
    else {
      if let id = id {
        TwitterClient.sharedInstance.likeTweetWithID(id, completion: { (tweet, error) -> () in
          if let _ = tweet {
            self.liked = true
            self.likeCount += 1
          }
        })
      }
    }
    success(self)
  }
  
  func toggleRetweet(success: (Tweet) -> ()) {
    if retweeted {
      if let id = id {
        TwitterClient.sharedInstance.unretweetTweetWithID(id, completion: { (tweet, error) -> () in
          if let _ = tweet {
            self.retweeted = false
            self.retweetCount -= 1
          }
        })
      }
    }
    else {
      if let id = id {
        TwitterClient.sharedInstance.retweetTweetWithID(id, completion: { (tweet, error) -> () in
          if let _ = tweet {
            self.retweeted = true
            self.retweetCount += 1
          }
        })
      }
    }
    success(self)
  }
}