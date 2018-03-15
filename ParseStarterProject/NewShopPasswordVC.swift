//
//  NewShopPasswordVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/7/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class NewShopPasswordVC: UIViewController {

    var user: PFUser!
    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    var firstPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
        passwordField.underline()
    }
    
    @IBAction func proceed(_ sender: UIButton) {
        guard let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines), password.count > 0 else {
            CommonUtils.popUpAlert(message: "Please enter a password", sender: self)
            return
        }
        if firstPassword == nil {
            firstPassword = passwordField.text
            passwordField.text = ""
            sender.setTitle("Submit", for: .normal)
            sender.isEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                self.prompt.alpha = 0.0
            }, completion: {(true) in
                self.prompt.center.x -= self.view.bounds.width
                self.prompt.alpha = 1.0
                self.prompt.text = "RE-ENTER PASSWORD"
                UIView.animate(withDuration: 0.25, animations: {
                    self.view.layoutIfNeeded()
                    sender.isEnabled = true
                })
            })
        }
        else {
            if self.firstPassword == self.passwordField.text {
                sender.isEnabled = false
                user.password = self.firstPassword!
                signup()
            }
            else {
                CommonUtils.popUpAlert(message: "Passwords must match - try again!", sender: self)
                self.firstPassword = nil
                self.prompt.text = "CHOOSE A PASSWORD"
                self.passwordField.text = ""
                sender.setTitle("Continue", for: .normal)
            }
        }
    }
    
    private func signup() {
        self.user.signUpInBackground() { (success, error) in
            guard error == nil else {
                let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
                let vc = nav.viewControllers.first as! LandingOptionsVC
                vc.errorMessage = error?.localizedDescription
                self.present(nav, animated: true, completion: nil)
                return
            }
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "shopTabBarController")
            self.present(vc, animated: true, completion: nil)
        }
    }
}
