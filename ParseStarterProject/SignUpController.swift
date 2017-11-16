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
    private let prompts = ["What's your email address?", "Whats your first name?", "Whats your last name?", "What's your password?"]
    private var userInfo: [String?] = [nil, nil, nil, nil]
    
    @IBAction func proceed(_ sender: UIButton) {
        guard let userInput = input.text?.trimmingCharacters(in: .whitespacesAndNewlines), userInput.count > 0 && currentPage < prompts.count else {
            errorLabel.isHidden = false
            return
        }
        errorLabel.isHidden = true
        userInfo[currentPage] = userInput
        input.text = ""
        currentPage += 1
        if currentPage == userInfo.count {
            signUp(userInfo[0]!, userInfo[1]!, userInfo[2]!, userInfo[3]!)
            return
        }
        else if currentPage == userInfo.count - 1 {
            sender.setTitle("Submit", for: .normal)
        }
        prompt.text = prompts[currentPage]
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
        guard let loginVC = segue.destination as? ViewController, let errMsg = loginErrorMsg else { return }
        loginVC.errMsgStr = errMsg + ": " + (userInfo[0] ?? "")
    }

    @IBAction func cancelSignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToLoginScreen", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prompt.text = prompts[currentPage]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        prompt.center.x -= view.bounds.width
        // animate it from the left to the right
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.prompt.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
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
