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
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
        self.present(nav, animated: true, completion: nil)
    }
}
