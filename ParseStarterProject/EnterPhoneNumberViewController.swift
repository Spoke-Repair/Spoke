//
//  EnterPhoneNumberViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 1/24/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class EnterPhoneNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDesignShape()
        self.allowHideKeyboardWithTap()
        self.phoneField.delegate = self
    }

    @IBAction func submit() {
        guard self.phoneField.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil else {
            CommonUtils.popUpAlert(message: "Please enter a valid phone number", sender: self)
            return
        }
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "AddBikeViewController") as! AddBikeViewController
        vc.phoneNumber = CommonUtils.strip(from: phoneField.text!, characters: ["(", ")", " ", "-"])
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.applyPhoneFormatForUITextFieldDelegate(replacementString: string, currentlyEnteringPhone: true)
    }
}
