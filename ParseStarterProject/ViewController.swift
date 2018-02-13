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
    //Used to store error message coming from account creation segue
    var errMsgStr: String?

    @IBOutlet var otherLabel: UILabel!
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var errorMsg: UILabel!
    @IBOutlet var username: UITextField!
    var password = ""
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var changeMode: UIButton!
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        var newString = ""
        
        //alternative logic to see if character was deleted
        if(newLength < (textField.text?.count)! && phoneNumberEntered == false) {
            
            //(210) - 4
            
            if(newLength == 8){
                print("Should remove spaces dash and parenthesis")
                textField.text = textField.text!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
                textField.text = textField.text!.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                textField.text = textField.text!.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)

            }
            
            //(210) - 432 -
            //length 14
            if(newLength == 14) {
                newString = textField.text!
                
                newString.removeLast()
                newString.removeLast()
                newString.removeLast()
                textField.text = newString
            }
            
            if(newLength == 13) {
                newString = textField.text!
                newString.removeLast()
                newString.removeLast()
                textField.text = newString
            }
            
            return true
        }
        
        
        
        if(phoneNumberEntered == false){
            
            if(newLength == 1){
            
                textField.text! += "("
            
            }
            
            if(newLength == 4) {
                
                newString = textField.text! + string + ") - "
                textField.text = newString
                return false
            }
            
            if(newLength == 5){
                newString = textField.text! + ") - " + string
                textField.text = newString
                return false
            }
            
            if(newLength == 11) {
                
                newString = textField.text! + string + " - "
                textField.text = newString
                return false
            }
            
            if(newLength == 12) {
                newString = textField.text! + " - " + string
                textField.text = newString
                return false
            }
            
            
            
            if(newLength == 18) {
                textField.text = textField.text! + string
            
                UIView.animate(withDuration: 1, animations: {
                
                    self.phoneNumber = textField.text!
                    self.phoneNumberEntered = true
                    textField.placeholder = "Enter a password"
                    textField.text = ""
                    //create button for end of text input
                
                    let button = UIButton(type: .custom)
                    button.setImage(UIImage(named: "arrow-right-gray.png"), for: .normal)
                    button.imageEdgeInsets = UIEdgeInsetsMake(2, -16, 2, 10)
                    button.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(10), height: CGFloat(14))
                    button.addTarget(self, action: #selector(self.login), for: .touchUpInside)
                    self.instructionLabel.text = "ENTER YOUR PASSWORD"
                    self.otherLabel.text = "Welcome"
                    textField.rightView = button
                    textField.keyboardType = UIKeyboardType.default
                    textField.isSecureTextEntry = true
                    textField.rightViewMode = .always
                
                
                    self.username.center.x += self.view.bounds.width
                }, completion: nil)
            
                return false
            
            }
            
        } else {
            textField.text = textField.text! + string
            self.password = textField.text!
            print("Password in function is: \(self.password)")
            return false
        }
        
        
        return true
    }
    
   
    @IBAction func login(_ sender: Any) {

            self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
            self.phoneNumber = self.phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
            self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
            self.phoneNumber = self.phoneNumber.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        print("Phone number: \(self.phoneNumber)")
        print("Password: \(self.password)")
        
        
        
            PFUser.logInWithUsername(inBackground: self.phoneNumber, password: self.password, block: {(user, error) in

                if error != nil {
                    CommonUtils.popUpAlert(message: "Your password is incorrect", sender: self)
                } else {
                    print("Login success")
                    //print(user!["type"])
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
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username.delegate = self
    
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
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
 
 
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
