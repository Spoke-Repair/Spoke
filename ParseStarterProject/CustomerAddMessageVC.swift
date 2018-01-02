//
//  CustomerAddMessageVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/5/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class CustomerAddMessageVC: UIViewController {

    @IBOutlet var messageField: UITextField!

    @IBAction func submitCustomerMessage(_ sender: Any) {
        //proceed if not nil and not empty
        guard !(messageField.text ?? "").isEmpty else {
            CommonUtils.popUpAlert(message: "Enter a message before submission", sender: self)
            return
        }

        //make the Message Object
        let messageObject = PFObject(className: "OrderMessages")
        messageObject["bikeID"] = customerBikeIDList[customerIndex]
        messageObject["message"] = messageField.text
        messageObject["UserType"] = "customer"
        messageObject["UserID"] = PFUser.current()?.objectId
        messageObject.saveInBackground(block: { (bool: Bool, error: Error?) in
            guard error == nil else {
                //Can take over 15 seconds to alert user if no internet connection
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                return
            }
            _ = self.navigationController?.popViewController(animated: true)
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomerAddMessageVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.messageField.underline()
    }

    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
