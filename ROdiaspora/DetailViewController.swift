//
//  DetailViewController.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 06/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {
  
  
  @IBAction func closePressed() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func facebookSharePressed() {
    if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
      let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
      //fbShare.add(<#T##image: UIImage!##UIImage!#>)
      //fbShare.setInitialText(<#T##text: String!##String!#>)
      //fbShare.add(<#T##url: URL!##URL!#>)
      
      self.present(fbShare, animated: true, completion: nil)
    }
    else {
      let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func twitterSharePressed() {
    if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
      
      let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      
      self.present(tweetShare, animated: true, completion: nil)
      
    } else {
      
      let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
}
