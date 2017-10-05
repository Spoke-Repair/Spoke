//
//  FoundBikeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class FoundBikeViewController: UIViewController {

    var userId: String? = nil

    @IBAction func backToScanner(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeTabBarController")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func viewBikeInfo(_ sender: Any) {
        self.performSegue(withIdentifier: "viewBikeInfo", sender: self)

    }
    
    
    @IBAction func goToOpenWorkOrder(_ sender: Any) {
        self.performSegue(withIdentifier: "createWorkOrderSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Im in prepare segue and my ID is: "+userId!)
        if segue.identifier == "viewBikeInfo" {
            print("in view bike info")
            if let displayBikeVC = segue.destination as? DisplayBikeDataViewController {
                displayBikeVC.userId = self.userId
                print("display bike vc")
            }

        }else if segue.identifier == "backToScanner" {
                //see if back button works from found FoundBikeViewController
                print("hit the back button from FoundBikeViewController")
                //self.performSegue(withIdentifier: "backToScanner", sender: self)
            
        }else if segue.identifier == "createWorkOrderSegue" {
            if let workVC = segue.destination as? CreateWorkOrderViewController {
                workVC.bikeID = self.userId
            }
        
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
