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
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
            CommonUtils.popUpAlert(message: "Can't transiton to view", sender: self)
            return
        }
        self.present(vc, animated: true, completion: nil)
    }
}
