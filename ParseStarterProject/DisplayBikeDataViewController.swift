//
//  DisplayBikeDataViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class DisplayBikeDataViewController: UIViewController {
    
    var userId: String? = nil
    
    @IBOutlet var theModelLabel: UILabel!
    @IBOutlet var theMakeLabel: UILabel!
    @IBOutlet var firstname: UILabel!
    @IBOutlet var lastname: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        self.performSegue(withIdentifier: "backToBikeInfo", sender: self)
    }
    
    @IBAction func textCustomer(_ sender: Any) {
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let query = PFQuery(className: "Bike")
        if let userID = userId{
            print("user ID: "+userID)
            query.whereKey("objectId", equalTo: userID)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    if let objects = objects {
                        //for object in objects {
                            print("printing items from parse query")
                            print(objects[0]["userID"])
                            print(objects[0]["model"])
                            self.theModelLabel.text = objects[0]["model"] as? String
                            self.theMakeLabel.text = objects[0]["make"] as? String
                        
                            let userQuery = PFUser.query()

                        
                            userQuery?.whereKey("objectId", equalTo: objects[0]["userID"])
                            userQuery?.findObjectsInBackground(block: { (users: [PFObject]?, error: Error?) in
                                self.firstname.text = users?[0]["firstname"] as? String
                                self.lastname.text = users?[0]["lastname"] as? String
                            })
                        //}
                        
                    }
                }else {
                    //there was an error
                    print("There was an error...")
                }
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToBikeInfo" {
            if let foundBikeVC = segue.destination as? FoundBikeViewController {
                foundBikeVC.userId = self.userId
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
