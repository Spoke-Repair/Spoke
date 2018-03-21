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
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    var currentlyEnteringPhone = true
    var phoneNumber = ""
    
    @IBOutlet var otherLabel: UILabel!
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.applyPhoneFormatForUITextFieldDelegate(replacementString: string, currentlyEnteringPhone: currentlyEnteringPhone)
    }
    
    @objc func login(_ sender: UIButton) {
        sender.isEnabled = false
        guard !(textField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter your password", sender: self)
            sender.isEnabled = true
            return
        }
        let strippedNumber = CommonUtils.strip(from: self.phoneNumber, characters: ["(", ")", " ", "-"])
        PFUser.logInWithUsername(inBackground: strippedNumber, password: textField.text!, block: { (user, error) in
            guard error == nil else {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                sender.isEnabled = true
                return
            }

            PFCloud.callFunction(inBackground: "generateFirebaseToken", withParameters: ["uid": PFUser.current()!.objectId!]) { (response: Any?, error: Error?) in
                guard error == nil else {
                    CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                    sender.isEnabled = true
                    return
                }
                Auth.auth().signIn(withCustomToken: response as! String) { (user1, error) in
                    guard error == nil else {
                        CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                        sender.isEnabled = true
                        return
                    }
                    let type = user!["type"] as! String
                    if type == "employee" {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "shopTabBarController")
                        self.present(vc, animated: true, completion: nil)
                    }
                    else {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "customerTabBar")
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
    @objc private func proceedToPassword() {
        guard textField.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil else {
            CommonUtils.popUpAlert(message: "Please enter your complete phone number", sender: self)
            return
        }
        self.phoneNumber = textField.text!
        self.currentlyEnteringPhone = false
        textField.placeholder = "Enter a password"
        textField.text = ""
        UIView.animate(withDuration: 1, animations: {
            //create button for end of text input
            let rightButton = UIButton(type: .custom)
            rightButton.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
            rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 10)
            rightButton.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            rightButton.addTarget(self, action: #selector(self.login), for: .touchUpInside)
            self.textField.rightView = rightButton
            self.textField.rightViewMode = .always
            
            //create button to go back
            let leftButton = UIButton(type: .custom)
            leftButton.setImage(UIImage(named: "arrow-right-gray.png")?.withHorizontallyFlippedOrientation(), for: .normal)
            leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -10)
            leftButton.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            leftButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
            self.textField.leftView = leftButton
            self.textField.leftViewMode = .always

            self.instructionLabel.text = "ENTER YOUR PASSWORD"
            self.otherLabel.text = "Welcome"
            self.textField.keyboardType = UIKeyboardType.default
            self.textField.isSecureTextEntry = true
            self.textField.center.x += self.view.bounds.width
        }, completion: nil)
    }
    
    @objc private func goBack() {
        UIView.animate(withDuration: 1, animations: {
            
            //Reinstate old prompts
            self.currentlyEnteringPhone = true
            self.phoneNumber = ""
            self.instructionLabel.text = "LOGIN TO ACCOUNT"
            self.otherLabel.text = "Enter the phone number that identifies your account"
            
            //Remove left button
            self.textField.text = ""
            self.textField.placeholder = "Phone number"
            self.textField.leftView = nil
            self.textField.leftViewMode = .never
            self.textField.keyboardType = .numberPad
            self.textField.isSecureTextEntry = false
            self.textField.center.x -= self.view.bounds.width
            
            //Create button for right end of text input
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 10)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            button.addTarget(self, action: #selector(self.proceedToPassword), for: .touchUpInside)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
            
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
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 10)
            button.frame = CGRect(x: CGFloat(self.textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
            button.addTarget(self, action: #selector(self.proceedToPassword), for: .touchUpInside)
            self.textField.rightView = button
            self.textField.rightViewMode = .always
        }, completion: nil)
    }
}

