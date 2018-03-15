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
        self.addDesignShape()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let nav = self.storyboard!.instantiateViewController(withIdentifier: "option_nav") as! UINavigationController
        self.present(nav, animated: true, completion: nil)
    }
}
