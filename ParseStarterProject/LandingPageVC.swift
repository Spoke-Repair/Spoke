//
//  LandingPageVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/6/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class LandingPageVC: UIViewController {

    var loginError: Error?

    override func viewDidAppear(_ animated: Bool) {
        guard loginError?.localizedDescription == nil else {
            CommonUtils.popUpAlert(message: loginError!.localizedDescription, sender: self)
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.view.frame.height - 100))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.width))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.view.frame.height))
        path.close()
        
        let triangle = CAShapeLayer()
        triangle.path = path.cgPath
        triangle.fillColor = UIColor.cyan.cgColor
        self.view.layer.addSublayer(triangle)
    }
}
