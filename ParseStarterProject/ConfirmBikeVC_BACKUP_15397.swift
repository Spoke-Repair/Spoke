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
//            guard error == nil else {
//                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
//                return
//            }
            if(success == true) {
                var phoneNumber:String = self.newBike["phone"] as! String
                
                phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
                phoneNumber = "+1" + phoneNumber
                
                PFCloud.callFunction(inBackground: "smsMessage", withParameters: ["number": phoneNumber, "bikecode": self.newBike.objectId], block: { (object: Any?, error: Error?) in
                    print("ConfirmBikeVC: sending sms message \(String(describing: self.newBike.objectId))")
                    if(error != nil) {
                        print("ConfirmBikeVC: An error occured while sending message")
                        CommonUtils.popUpAlert(message: "An error occured sending message", sender: self)
                    }else{
                        print("ConfirmBikeVC: You sent the sms messsage!")
                    }
                    
                })
            }else{
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)

            }
<<<<<<< HEAD
           
            
                
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : UITabBarController = storyboard.instantiateViewController(withIdentifier: "shopTabBarController") as! UITabBarController
=======
            let vc : UITabBarController = self.storyboard!.instantiateViewController(withIdentifier: "shopTabBarController") as! UITabBarController
>>>>>>> a1483bb6ceea7f2e9c7355ecb2433c70e901e3ef
            self.present(vc, animated: true, completion: nil)
        })
    }
}
