//
//  ConfirmBikeVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ConfirmBikeVC: UIViewController {
    
    var userId: String? = nil
    var bikeId: String? = nil
    var make: String? = nil
    var model: String? = nil
    var type: String? = nil
    
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var bikeIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.bikeIDLabel.text = bikeId
        self.makeLabel.text = make
        self.modelLabel.text = model
        self.typeLabel.text = type
    }
    
    @IBAction func confirmBike(_ sender: Any) {
        let query = PFQuery(className: "Bike")
        query.whereKey("objectId", equalTo: bikeId!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if (error == nil){
                if let object = objects?[0] {
                    object["isOwned"] = true
                    object["model"] = self.model
                    object["userID"] = self.userId
                    object["make"] = self.make
                    object["size"] = self.type
                    object.saveInBackground(block: { (success:Bool, error: Error?) in
                        if(success){
                            self.performSegue(withIdentifier: "backToBikeListSegue", sender: self)
                        }
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToBikeListSegue" {
            let navVC = segue.destination as? UINavigationController
            let vc = navVC?.viewControllers.first as! BikeListController

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
