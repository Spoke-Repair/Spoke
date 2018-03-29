//
//  ShopInventoryCell.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/21/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class ShopInventoryCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    var bike: PFObject!
    var workOrders: Set<PFObject>!
}
