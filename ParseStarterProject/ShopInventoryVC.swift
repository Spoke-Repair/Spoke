//
//  ShopInventoryVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/21/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Parse

class ShopInventoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var workOrders: [PFObject] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        guard let currentUser = PFUser.current() else {
            CommonUtils.popUpAlert(message: "Error: No user logged in", sender: self)
            return
        }
        
        let query = PFQuery(className: "WorkOrder")
        query.whereKey("shop", equalTo: currentUser)
        query.whereKey("isOpen", equalTo: true)
        query.findObjectsInBackground() { (orders: [PFObject]?, error: Error?) in
            guard error == nil, let orders = orders else {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                return
            }
            for workOrder in orders {
                self.workOrders.append(workOrder)
            }
        }
        
        self.collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfItemsInSelection: Int) -> Int {
        return self.workOrders.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopInventoryCell", for: indexPath) as! ShopInventoryCell
        return cell
    }
}
