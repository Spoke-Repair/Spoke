//
//  QRCodeGeneratorViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class QRCodeGeneratorViewController: UIViewController {

    @IBOutlet var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let user = PFUser.current();
        var uniqueCode: String? = nil
        let newBike = PFObject(className: "Bike")
        newBike["isOwned"] = false
        newBike.saveInBackground { (success:Bool, error: Error?) in
            if(success){
                print("Made a new Bike")
                uniqueCode = newBike.objectId
                let data = uniqueCode?.data(using: .ascii, allowLossyConversion: false)
                let filter = CIFilter(name: "CIQRCodeGenerator")
                filter?.setValue(data, forKey: "inputMessage")
                
                let qrCodeImage = filter?.outputImage
                let scaleX = self.myImageView.frame.size.width / (qrCodeImage?.extent.size.width)!
                let scaleY = self.myImageView.frame.size.height / (qrCodeImage?.extent.size.height)!
                
                
                let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                
                
                //let img = UIImage(ciImage: (filter?.outputImage)!)
                //myImageView.image = img
                
                if let output = filter?.outputImage?.applying(transform){
                    let img = UIImage(ciImage: output)
                    self.myImageView.image = img
                    
                }

            }
            
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
