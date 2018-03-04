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
        self.allowHideKeyboardWithTap()
        self.message.underline()
    }
}
