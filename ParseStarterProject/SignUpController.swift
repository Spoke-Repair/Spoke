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

    @IBOutlet weak var prompt: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var input: UITextField!

    private var loginErrorMsg: String?
    private var currentPage = 0
    private let prompts = ["What's your email address?", "Whats your first name?", "Whats your last name?", "What's your password?", "Re-enter your password"]
    private var userInfo: [String?] = [nil, nil, nil, nil, nil]
    
    @IBAction func proceed(_ sender: UIButton) {
        guard let userInput = input.text?.trimmingCharacters(in: .whitespacesAndNewlines), userInput.count > 0 && currentPage < prompts.count else {
            errorLabel.isHidden = false
            return
        }
        errorLabel.isHidden = true
        userInfo[currentPage] = userInput
        input.text = ""
        currentPage += 1
        if currentPage == prompts.count {

            //Ensure that user typed password correctly
            guard userInfo[3] == userInfo[4] else {
                self.loginErrorMsg = "Failed - passwords must match for user"
                self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
                return
            }

            signUp(userInfo[0]!, userInfo[1]!, userInfo[2]!, userInfo[3]!)
            return
        }
        else if currentPage == prompts.count - 1 {
            sender.setTitle("Submit", for: .normal)
        }

        sender.isEnabled = false
        UIView.animate(withDuration: 0.25, animations: {
            self.prompt.alpha = 0.0
        }, completion: {(true) in
            self.prompt.center.x -= self.view.bounds.width
            self.prompt.alpha = 1.0
            self.prompt.text = self.prompts[self.currentPage]
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                sender.isEnabled = true
            })
        })
    }

    private func signUp(_ email: String, _ first: String, _ last: String, _ pass: String) {
        let user = PFUser()
        user.username = email
        user.password = pass
        user["firstname"] = first
        user["lastname"] = last
        user["type"] = "customer"
        user.signUpInBackground() { (success, error) in
            if error != nil {
                print("Failed to create account \(email)")
                self.loginErrorMsg = error?.localizedDescription
                self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
                return
            }
            print("Created account \(email)")
            user.saveInBackground(block: { (success: Bool, error: Error?) in
                if(success){
                    self.performSegue(withIdentifier: "signUpActivated", sender: self)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let loginVC = segue.destination as? ViewController, let errMsg = self.loginErrorMsg else { return }
        loginVC.errMsgStr = errMsg + ": " + (userInfo[0] ?? "")
    }

    @IBAction func cancelSignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prompt.text = self.prompts[self.currentPage]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
