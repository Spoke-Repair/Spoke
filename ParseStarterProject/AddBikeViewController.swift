//
//  AddBikeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class AddBikeViewController: UIViewController {

    var phoneNumber: String!
    @IBOutlet var makeLabel: UITextField!
    @IBOutlet var modelLabel: UITextField!
    @IBOutlet var sizeLabel: UITextField!

    @IBAction func goToScanner(_ sender: Any) {
        if !(makeLabel.text ?? "").isEmpty && !(modelLabel.text ?? "").isEmpty && !(sizeLabel.text ?? "").isEmpty {
            self.performSegue(withIdentifier: "scanQRSegue", sender: self)
        }
        else {
            CommonUtils.popUpAlert(message: "Please populate fields before proceeding", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHideKeyboardWithTap()
        self.makeLabel.underline()
        self.modelLabel.underline()
        self.sizeLabel.underline()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanQRSegue", let addBikeVC = segue.destination as? AddBikeScannerVC {
            let newBike = PFObject(className: "Bike")
            newBike["phone"] = self.phoneNumber
            newBike["make"] = self.makeLabel.text
            newBike["model"] = self.modelLabel.text
            newBike["size"] = self.sizeLabel.text
            addBikeVC.newBike = newBike
        }
    }
}
