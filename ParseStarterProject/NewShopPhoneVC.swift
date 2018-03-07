//
//  NewShopPhoneVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/7/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class NewShopPhoneVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHideKeyboardWithTap()
        self.addDesignShape()
        self.phoneField.underline()
        self.phoneField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.applyPhoneFormatForUITextFieldDelegate(replacementString: string, currentlyEnteringPhone: true)
    }

    @IBAction func submitNumber() {
        guard self.phoneField.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil else {
            CommonUtils.popUpAlert(message: "Please enter a valid phone number", sender: self)
            return
        }
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "NewShopAddressVC") as! NewShopAddressVC
        let user = PFUser()
        user.username = CommonUtils.strip(from: self.phoneField.text!, characters: ["(", "-", ")", " "])
        user["type"] = "employee"
        vc.user = user
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
