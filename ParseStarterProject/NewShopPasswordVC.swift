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
    var loginError: Error?
    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    var firstPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.underline()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.view.frame.height - 100))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.width))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.view.frame.height))
        path.close()
        
        let triangle = CAShapeLayer()
        triangle.path = path.cgPath
        triangle.fillColor = UIColor(red:0.79, green:0.93, blue:0.98, alpha:1.0).cgColor
        self.view.layer.addSublayer(triangle)
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
        self.user.signUpInBackground() { (success1, error1) in
            guard error1 == nil else {
                self.loginError = error1
                self.performSegue(withIdentifier: "failedLoginSegue", sender: self)
                return
            }
            print("Saved account for \(self.user.username!)")
            self.user.saveInBackground(block: { (success: Bool, error2: Error?) in
                guard error2 == nil else {
                    self.loginError = error2
                    self.performSegue(withIdentifier: "failedLoginSegue", sender: self)
                    return
                }
                self.performSegue(withIdentifier: "signUpSuccessSegue", sender: self)
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "failedLoginSegue", let landingVC = segue.destination as? LandingPageVC {
            landingVC.loginError = self.loginError
        }
    }

}
