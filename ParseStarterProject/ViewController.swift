/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory. hello
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    var signupMode = true
    var phoneNumberEntered = false
    var phoneNumber = ""
    //Used to store error messages to display when account creation fails
    var errMsgStr: String?

    @IBOutlet var otherLabel: UILabel!
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var noAccountLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Not currently entering a phone number, so proceed normally
        if phoneNumberEntered {
            return true
        }
        
        //Deleting character, and any preceeding non-numeric characters
        if string.isEmpty {
            textField.text = textField.text!.replacingOccurrences(of: "\\D*\\d$", with: "", options: .regularExpression)
            return false
        }

        //Prevent pasting into the text field and non-numerics and attempting too many characters
        if string.count > 1 || string.range(of: "\\D", options: .regularExpression) != nil || textField.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil {
            return false
        }
        
        //Potentially obtain phone formatting characters to suffix the current string
        let regexToFormat: [String: String] = ["^$": "(", "^\\(\\d{3}$": ") - ", "^\\(\\d{3}\\) - \\d{3}$": " - "]
        for (key, val) in regexToFormat {
            if textField.text!.range(of: key, options: .regularExpression) != nil {
                textField.text! += val
                break
            }
        }
        
        return true
    }
    
    @objc func login(_ sender: Any) {
        guard !(textField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter your password", sender: self)
            return
        }
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        print("Phone number: \(self.phoneNumber)")
        print("Password: \(textField.text!)")
        
        PFUser.logInWithUsername(inBackground: self.phoneNumber, password: textField.text!, block: {(user, error) in
            if error != nil {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
            } else {
                print("Login success")
                let type = user!["type"] as! String
                if type == "employee"{
                    print("logging in as employee")
                    self.performSegue(withIdentifier: "loginEmployee", sender: self)
                } else {
                    //segue to customer storyboard
                    print("logging in as customer")
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        })
    }
    
    @objc private func proceedToPassword() {
        guard textField.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil else {
            CommonUtils.popUpAlert(message: "Please enter your phone number", sender: self)
            return
        }
        signUpButton.isHidden = true
        noAccountLabel.isHidden = true
        self.phoneNumber = textField.text!
        self.phoneNumberEntered = true
        textField.placeholder = "Enter a password"
        textField.text = ""
        UIView.animate(withDuration: 1, animations: {
            //create button for end of text input
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(2, -16, 2, 10)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
            self.textField.rightView = button
            self.textField.rightViewMode = .always

            self.instructionLabel.text = "ENTER YOUR PASSWORD"
            self.otherLabel.text = "Welcome"
            self.textField.keyboardType = UIKeyboardType.default
            self.textField.isSecureTextEntry = true
            self.textField.center.x += self.view.bounds.width
        }, completion: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
        self.textField.underline()
        
        UIView.animate(withDuration: 1, animations: {
            //create button for end of text input
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(2, -16, 2, 10)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            button.addTarget(self, action: #selector(self.proceedToPassword), for: .touchUpInside)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.current() != nil) {
            print(PFUser.current()?["type"]! as! String)
            if let userType = PFUser.current()?["type"] as? String! {
                if userType == "employee" {
                    self.performSegue(withIdentifier: "loginEmployee", sender: self)
                }else{
                    self.performSegue(withIdentifier: "login", sender: self)
                }
            }
        }
        else if let errMsgStr = errMsgStr {
            CommonUtils.popUpAlert(message: errMsgStr, sender: self)
        }
    }
}
