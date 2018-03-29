//
//  ShopIndividualBikeVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/28/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class ShopIndividualBikeVC: UIViewController {
    var bike: PFObject!
    var workOrders: Set<PFObject>!
    var tempImage: UIImage!
    @IBOutlet weak var bikeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bikeImage.image = self.tempImage
    }
}
