//
//  SettingsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {
    @IBAction func logoutButton(_ sender: Any) {
        PFUser.logOut()
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
}
