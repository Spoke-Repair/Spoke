//
//  ActivateBikeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 1/26/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class ActivateBikeViewController: UIViewController {

    @IBOutlet weak var activationCodeField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
    }
    
    @IBAction func activateCode() {
        guard let code = activationCodeField.text, !code.isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter a valid activation code", sender: self)
            return
        }

        let query = PFQuery(className: "Bike")
        query.whereKey("bikeID", equalTo: code)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            guard error == nil else {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                return
            }
            guard objects != nil && objects!.count > 0 else {
                CommonUtils.popUpAlert(message: "Invalid bike ID", sender: self)
                return
            }
            guard objects!.count == 1 else {
                CommonUtils.popUpAlert(message: "Warning: Multiple IDs associated with this activation code", sender: self)
                return
            }
            guard let currentUser = PFUser.current() else {
                CommonUtils.popUpAlert(message: "Error - currently not logged in as a user", sender: self)
                return
            }

            let bike = objects![0]
            bike["userID"] = currentUser.objectId
            bike.acl!.setWriteAccess(true, for: currentUser) //this is not changing the write permissions as it should be

            bike.saveInBackground {
                (success: Bool, error: Error?) in
                guard success && error == nil else {
                    CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                    return
                }
                CommonUtils.popUpAlert(message: "Success!", sender: self)
            }
        }

    }
}
