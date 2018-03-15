//
//  CustomerEnterAuthVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/28/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class CustomerEnterAuthVC: UIViewController {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var user:PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
        self.textField.underline()
    }
    
    @IBAction func login() {
        
        //Ensure text field is not empty
        guard let user = self.user, !(textField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter the code", sender: self)
            return
        }
        
        //Obtain bike from the object id the user provided
        let query = PFQuery(className: "Bike")
        query.getObjectInBackground(withId: self.textField.text!) { (bike: PFObject?, error: Error?) in
            
            //Ensure query was successful
            guard let bike = bike, error == nil else {
                let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
                let vc = nav.viewControllers.first as! LandingOptionsVC
                vc.errorMessage = error?.localizedDescription
                self.present(nav, animated: true, completion: nil)
                return
            }
            
            guard bike["userID"] == nil else {
                let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
                let vc = nav.viewControllers.first as! LandingOptionsVC
                vc.errorMessage = "That item already has an owner!"
                self.present(nav, animated: true, completion: nil)
                return
            }
            
            //Verify the phone number for the bike matches the user's number
            guard bike["phone"] as? String == user.username else {
                let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
                let vc = nav.viewControllers.first as! LandingOptionsVC
                vc.errorMessage = "Your phone number doesn't match the number for that item!"
                self.present(nav, animated: true, completion: nil)
                return
            }
            
            //Sign up user
            user.signUpInBackground() {(success: Bool, error: Error?) in
                guard error == nil else {
                    let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
                    let vc = nav.viewControllers.first as! LandingOptionsVC
                    vc.errorMessage = error?.localizedDescription
                    self.present(nav, animated: true, completion: nil)
                    return
                }
                
                //Update bike to acknowledge new owner
                bike["userID"] = user.objectId
                bike.saveInBackground() { (success, error) in
                    guard success && error == nil else {
                        let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
                        let vc = nav.viewControllers.first as! LandingOptionsVC
                        vc.errorMessage = error?.localizedDescription
                        self.present(nav, animated: true, completion: nil)
                        return
                    }
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "customerTabBar")
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}
