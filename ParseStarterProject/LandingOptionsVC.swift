//
//  LandingOptionsVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/14/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class LandingOptionsVC: UIViewController {
    
    //Used to store error messages to display when account creation fails
    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.current() != nil {
            print(PFUser.current()?["type"]! as! String)
            if let userType = PFUser.current()?["type"] as? String! {
                if userType == "employee" {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "shopTabBarController")
                    self.present(vc, animated: true, completion: nil)
                }
                else {
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "customerTabBar")
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        else if let errorMessage = errorMessage {
            CommonUtils.popUpAlert(message: errorMessage, sender: self)
        }
        
        self.addDesignShape()
    }
    
    @IBAction func proceedToDelivery() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "delivery_nav")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func proceedToSignup() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "signup_nav")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func proceedToSignin() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
