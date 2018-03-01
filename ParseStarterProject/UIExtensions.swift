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
