//
//  UIExtensions.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 12/6/17.
//  Copyright © 2017 Parse. All rights reserved.
//
import UIKit

extension UITextField {

    func underline(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
