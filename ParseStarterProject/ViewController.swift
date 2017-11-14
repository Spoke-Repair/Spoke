/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true

    //Used to store error message coming from account creation segue
    var errMsgStr: String?
    
    @IBOutlet var errorMsg: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var changeMode: UIButton!
    @IBAction func signupOrLogin(_ sender: Any) {
    
            PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: {(user, error) in
                
                if error != nil {
                    
                    self.errorMsg.text = error?.localizedDescription
                    self.errorMsg.isHidden = false
                
                } else {
                    
                    print("Login success")
                    //print(user!["type"])
                    let type = user!["type"] as! String
                    if type == "employee"{
                        print("logging in as employee")
                        self.performSegue(withIdentifier: "loginEmployee", sender: self)

                    }else{
                        //segue to customer storyboard
                        print("logging in as customer")
                        self.performSegue(withIdentifier: "login", sender: self)
                    }
                }
            
            })
        
            
            
    }
    
    @IBAction func changeMode(_ sender: Any) {
       self.performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let str = errMsgStr {
            errorMsg.text = str
            errorMsg.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Im in the auto login")
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
