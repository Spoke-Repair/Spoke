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
    
    var newBike: PFObject!
    var bikePicture: UIImage?
    @IBOutlet var makeLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var sizeLabel: UILabel!
    @IBOutlet var pictureOfBike: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLabel.text = newBike["make"] as? String
        modelLabel.text = newBike["model"] as? String
        sizeLabel.text = newBike["size"] as? String
        pictureOfBike.image = bikePicture
    }
    
    @IBAction func confirmBike(_ sender: Any) {
        newBike["userID"] = PFUser.current()?.objectId
        newBike.saveInBackground(block: {(success:Bool, error: Error?) in
            guard error == nil else {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                return
            }
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : UITabBarController = storyboard.instantiateViewController(withIdentifier: "originalTabBar") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
        })
    }
}
