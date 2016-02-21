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
    TwitterClient.sharedInstance.login({ () -> () in
        print("I've logged in!")
        self.performSegueWithIdentifier("loginSegue", sender: self)
      }, failure: { (error: NSError) -> () in
        print(error.localizedDescription)
    })
  }

}

