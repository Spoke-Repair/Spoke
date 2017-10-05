//
//  SignUpController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SignUpController: UIViewController {

    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var lastNameText: UITextField!
    @IBOutlet var firstNameText: UITextField!
    
    @IBAction func cancelSignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let user = PFUser()
        user.username = self.emailText.text
        user.password = self.passwordText.text
        if self.emailText.text != nil && self.passwordText.text != nil && self.firstNameText != nil && self.lastNameText != nil {
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    
                    print("Sign up failed")
                    
                } else {
                    print("signed up")
                    user["type"] = "customer"
                    user["firstname"] = self.firstNameText.text
                    user["lastname"] = self.lastNameText.text
                    user.saveInBackground(block: { (success: Bool, error: Error?) in
                        if(success){
                            self.performSegue(withIdentifier: "signUpActivated", sender: self)

                        }
                    })
                }
                
            }
        }

    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBikeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
