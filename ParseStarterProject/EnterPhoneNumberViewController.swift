//
//  EnterPhoneNumberViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 1/24/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class EnterPhoneNumberViewController: UIViewController {

    @IBOutlet weak var phoneField: UITextField!

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "addBikeSegue":
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if segue.identifier == "addBikeSegue", let addBikeVC = segue.destination as? AddBikeViewController {
//        }
    }

}
