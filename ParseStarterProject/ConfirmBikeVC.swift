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
        newBike.saveInBackground(block: {(success:Bool, error: Error?) in
            guard error == nil else {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                return
            }
            let phoneNumber = "+1" + (self.newBike["phone"] as! String)
            PFCloud.callFunction(inBackground: "smsMessage", withParameters: ["number": phoneNumber, "bikecode": self.newBike.objectId!], block: { (object: Any?, error: Error?) in
                guard error == nil else {
                    //Accessing error!.localizedDescription stops the code in its tracks, yet does not throw an error? The debugger
                    //simply displays the following:
                    //2018-03-04 22:41:43.509115-0600 ParseStarterProject-Swift[2011:1313659] -[__NSDictionaryI length]: unrecognized selector sent to instance 0x1c42e1d00
                    //CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                    CommonUtils.popUpAlert(message: "Unable to send text message to customer at " + phoneNumber, sender: self)
                    return
                }
                print("ConfirmBikeVC: sending sms message \(self.newBike.objectId!)")
                let vc : UITabBarController = self.storyboard!.instantiateViewController(withIdentifier: "shopTabBarController") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
            })
        })
    }
}
