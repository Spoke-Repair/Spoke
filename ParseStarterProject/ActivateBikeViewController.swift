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
            let bike = objects![0]
            bike["userID"] = PFUser.current()?.objectId
            bike.saveInBackground() //Save is not working because this user doesn't have permission to write to that bike row
//            CommonUtils.popUpAlert(message: "Success!", sender: self)
        }

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
