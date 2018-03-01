//
//  NewShopPhoneVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/7/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class NewShopPhoneVC: UIViewController {

    @IBOutlet weak var phoneField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneField.underline()
        
        self.addDesignShape()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "addressSegue":
            if let numberStr = phoneField.text, numberStr.count == 10 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: numberStr)) {
                return true
            }
            else {
                CommonUtils.popUpAlert(message: "Please enter a valid phone number", sender: self)
                return false
            }
        default:
            break
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addressSegue", let addressVC = segue.destination as? NewShopAddressVC {
            let user = PFUser()
            user.username = phoneField.text
            user["type"] = "employee"
            addressVC.user = user
        }
    }
}
