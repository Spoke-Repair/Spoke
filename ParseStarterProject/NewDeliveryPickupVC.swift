//
//  NewDeliveryPickupVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/13/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class NewDeliveryPickupVC: UIViewController {
    
    var issueText: String!
    var phoneNumber: String!
    @IBOutlet weak var addressField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDesignShape()
        self.allowHideKeyboardWithTap()
        self.addressField.underline()
    }
    
    @IBAction func proceed() {
        guard let addressText = addressField.text, !addressText.isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter your address", sender: self)
            return
        }
        //TODO Submit pickup to database
    }
}
