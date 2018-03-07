//
//  UIExtensions.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 12/6/17.
//  Copyright © 2017 Parse. All rights reserved.
//
import UIKit

extension UITextField {
    func underline() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    //Use this method in "func textField(textField:range:string:) -> Bool" whenever the text field is restricted to a phone number
    func applyPhoneFormatForUITextFieldDelegate(replacementString string: String, currentlyEnteringPhone: Bool) -> Bool {
        //Not currently entering a phone number, so proceed normally
        if !currentlyEnteringPhone {
            return true
        }
        
        //Deleting character, and any preceeding non-numeric characters
        if string.isEmpty {
            self.text = self.text!.replacingOccurrences(of: "\\D*\\d$", with: "", options: .regularExpression)
            return false
        }
        
        //Prevent pasting into the text field and non-numerics and attempting too many characters
        if string.count > 1 || string.range(of: "\\D", options: .regularExpression) != nil || self.text!.range(of: "^\\(\\d{3}\\) - \\d{3} - \\d{4}$", options: .regularExpression) != nil {
            return false
        }
        
        //Potentially obtain phone formatting characters to suffix the current string
        let regexToFormat: [String: String] = ["^$": "(", "^\\(\\d{3}$": ") - ", "^\\(\\d{3}\\) - \\d{3}$": " - "]
        for (key, val) in regexToFormat {
            if self.text!.range(of: key, options: .regularExpression) != nil {
                self.text! += val
                break
            }
        }
        
        return true
    }
}

extension UIViewController {
    func addDesignShape() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.view.frame.height - 100))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.width))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.view.frame.height))
        path.close()
        
        let triangle = CAShapeLayer()
        triangle.path = path.cgPath
        triangle.fillColor = UIColor(red:0.79, green:0.93, blue:0.98, alpha:1.0).cgColor
        self.view.layer.insertSublayer(triangle, at: 0)
    }
    
    func allowHideKeyboardWithTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
