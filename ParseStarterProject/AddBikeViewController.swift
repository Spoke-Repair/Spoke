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

    @IBOutlet var makeLabel: UITextField!
    @IBOutlet var modelLabel: UITextField!
    @IBOutlet var sizeLabel: UITextField!
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "backToMyBikes", sender: self)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goToScanner(_ sender: Any) {
        if makeLabel.text?.count != 0 && modelLabel.text?.count != 0 && sizeLabel.text?.count != 0 {
            self.performSegue(withIdentifier: "scanQRSegue", sender: self)
        }
        else {
            CommonUtils.popUpAlert(message: "Please populate fields before proceeding", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBikeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.makeLabel.underline()
        self.modelLabel.underline()
        self.sizeLabel.underline()
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanQRSegue", let addBikeVC = segue.destination as? AddBikeScannerVC {
            let newBike = PFObject(className: "Bike")
            newBike["make"] = makeLabel.text
            newBike["model"] = modelLabel.text
            newBike["size"] = sizeLabel.text
            addBikeVC.newBike = newBike
        }
    }
}
