//
//  NewShopAddressVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 2/7/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class NewShopAddressVC: UIViewController {

    var user: PFUser!
    @IBOutlet weak var addressField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        addressField.underline()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.view.frame.height - 100))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.width))
        path.addLine(to: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.view.frame.height))
        path.close()
        
        let triangle = CAShapeLayer()
        triangle.path = path.cgPath
        triangle.fillColor = UIColor(red:0.79, green:0.93, blue:0.98, alpha:1.0).cgColor
        self.view.layer.addSublayer(triangle)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "newShopPhotoSegue":
            if !(addressField.text ?? "").isEmpty {
                return true
            }
            else {
                CommonUtils.popUpAlert(message: "Please enter a valid address", sender: self)
                return false
            }
        default:
            break
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newShopPhotoSegue", let photoVC = segue.destination as? NewShopPhotoVC {
            self.user["address"] = addressField.text!
            photoVC.user = self.user
        }
    }

}
