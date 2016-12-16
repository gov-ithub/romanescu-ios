//
//  DetailViewController.swift
//  ROdiaspora
//
//  Created by Marc Nicolae Popa on 06/12/2016.
//  Copyright © 2016 WIP. All rights reserved.
//

import UIKit
import Social
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
  
  @IBOutlet weak var imageView : UIImageView?
  @IBOutlet weak var nameLabel : UILabel?
  @IBOutlet weak var addressLabel : UILabel?
  @IBOutlet weak var phoneLabel : UILabel?
  @IBOutlet weak var scheduleLabel : UILabel?

  var locationObject : LocationObject? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setup()
  }
  
  func setup() {
    guard let locationObj = locationObject else {
      return
    }
    
    self.nameLabel?.text = "\(locationObj.name) din \(locationObj.country)"
    
    guard let imageView = imageView else {
      return
    }
    
    // test with this : 40.741895,-73.989308 (NY).
    // heading compass from 0 to 360 (0=North), pitch - specifies the up or down angle of the camera (-down and + up)
    Alamofire.request("https://maps.googleapis.com/maps/api/streetview?size=750x296&location=\(locationObj.latitude.doubleValue),\(locationObj.longitude.doubleValue)&heading=151.78&pitch=5&key=AIzaSyAVo_kku4oCd5qN-pyevtmh8_eqgzWZ82s").responseImage { response in
      
      if let image = response.result.value {
        imageView.image = image
      }
    }
  }
  
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
      tweetShare.add(<#T##url: URL!##URL!#>)
      tweetShare.add(<#T##image: UIImage!##UIImage!#>)
      tweetShare.setInitialText(<#T##text: String!##String!#>)
      self.present(tweetShare, animated: true, completion: nil)
      
    } else {
      
      let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
      
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
}
