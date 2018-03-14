//
//  NewDeliveryRequestVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/13/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class NewDeliveryRequestVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var issueTextField: UITextView!
    @IBOutlet weak var phoneField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDesignShape()
        self.allowHideKeyboardWithTap()
        self.phoneField.underline()
        self.phoneField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.applyPhoneFormatForUITextFieldDelegate(replacementString: string, currentlyEnteringPhone: true)
    }
    
    @IBAction func proceed() {
        guard let issueText = issueTextField.text, !issueText.isEmpty else {
            CommonUtils.popUpAlert(message: "Please enter your issue", sender: self)
            return
        }
        guard let phone = phoneField.text, phone.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil else {
            CommonUtils.popUpAlert(message: "Please enter your complete phone number", sender: self)
            return
        }
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "NewDeliveryPickupVC") as! NewDeliveryPickupVC
        vc.issueText = issueText
        vc.phoneNumber = phone
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

