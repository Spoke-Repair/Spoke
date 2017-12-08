//
//  AddMessageFromStoreVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/4/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class AddMessageFromStoreVC: UIViewController {

    @IBOutlet var message: UITextField!
    var bikeOwnerID: String = ""
    var bikeID: String = ""
    var storeID: String = ""
    
    
    
    @IBAction func submitMessage(_ sender: Any) {
        if self.message.text != nil {
            
            let messageObject = PFObject(className: "OrderMessages")
            messageObject["userID"] = bikeOwnerID
            messageObject["message"] = self.message.text!
            messageObject["StoreUserID"] = storeID
            messageObject["bikeID"] = bikeID
            messageObject["UserType"] = "employee"
            
            messageObject.saveInBackground(block: { (bool: Bool, error: Error?) in
                
                if error == nil {
                    //go back a controller (ignore return value and surpress warning by assigning value
                    //send notification
                    CommonUtils.sendMessageToParseUser(userID: self.bikeOwnerID, message: "You have a new message!")
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    print("Error occured saving Message object from Store User")
                }
                
            })
            
            
        }else{
            print("Dont leave the message field blank dumbass!")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMessageFromStoreVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.message.underline()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
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
