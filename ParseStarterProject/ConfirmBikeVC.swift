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
    var pictureOfBike: UIImage?

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var bikeIDLabel: UILabel!
    @IBOutlet var theImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.makeLabel.text = make
        self.modelLabel.text = model
        self.typeLabel.text = type
        self.theImageView.image = pictureOfBike
    }
    
    @IBAction func confirmBike(_ sender: Any) {
      
        
        
        let query = PFQuery(className: "Bike")
        query.whereKey("objectId", equalTo: bikeId!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            print("find objects")
            guard error == nil else {
                print(error!.localizedDescription)
            return
            }
            print("error is nil")
            print("objects: \(objects!)") // prints empty array
            print("objects![0]: \(objects![0])") //Never prints - but DOES NOT throw an error curiously
            guard let object = objects?[0] else {
                print("Unable to obtain object from query")
                return
            }
            print("passed guards")
            object["isOwned"] = true
            object["model"] = self.model
            object["userID"] = self.userId
            object["make"] = self.make
            object["size"] = self.type
            let imageData = UIImageJPEGRepresentation(self.pictureOfBike!, 0.1)
            let pimageFile = PFFile(data: imageData!)
            object["picture"] = pimageFile
            object.saveInBackground(block: { (success:Bool, error: Error?) in
                guard success, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
               // self.navigationController?.popToRootViewController(animated: false)
               // self.performSegue(withIdentifier: "bkSegue", sender: self)
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : UITabBarController = storyboard.instantiateViewController(withIdentifier: "originalTabBar") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
            
            })
        }
    }
    
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        
        //code
        
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
