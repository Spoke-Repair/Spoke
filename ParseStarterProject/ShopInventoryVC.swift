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
    
    //Need to be able to index into this structure for the collection view
    var bikeToWorkOrdersTuples: [(PFObject, Set<PFObject>)] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Ensure user is logged in
        guard let currentUser = PFUser.current() else {
            CommonUtils.popUpAlert(message: "Error: No user logged in", sender: self)
            return
        }
        
        //Reload everything. Number of elements will probably be same, so keep buffer
        bikeToWorkOrdersTuples.removeAll(keepingCapacity: true)
        
        //Create query for work orders
        let query = PFQuery(className: "WorkOrder")
        query.whereKey("shop", equalTo: currentUser)
        query.whereKey("isOpen", equalTo: true)
        query.includeKey("bike") //Allows access to bike without extra network request
        
        //Invoke query
        query.findObjectsInBackground() {[unowned self] (orders: [PFObject]?, error: Error?) in
            guard error == nil, let orders = orders else {
                CommonUtils.popUpAlert(message: error!.localizedDescription, sender: self)
                return
            }
            
            //Make dictionary from bike to work orders to prevent duplicate bikes
            var bikeToWorkOrders: [PFObject: Set<PFObject>] = [:]
            for order in orders {
                let bike = order["bike"] as! PFObject
                var workOrders = bikeToWorkOrders[bike]
                
                //If bike exists in dictionary, add work order to its set
                if var workOrders = workOrders {
                    workOrders.insert(order)
                }
                //Create new set, and make mapping between bike and that set
                else {
                    workOrders = Set<PFObject>()
                    workOrders!.insert(order)
                    bikeToWorkOrders[bike] = workOrders
                }
            }
            
            //Add tuples from map into list (use list bc we need elements to have indices for the collection view)
            for (k, v) in bikeToWorkOrders {
                self.bikeToWorkOrdersTuples.append((k, v))
            }
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection numberOfItemsInSelection: Int) -> Int {
        return self.bikeToWorkOrdersTuples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopInventoryCell", for: indexPath) as! ShopInventoryCell
        if let photo = self.bikeToWorkOrdersTuples[indexPath.row].0["picture"] as? PFFile {
            photo.getDataInBackground() { (data: Data?, error: Error?) in
                if error != nil {
                    print("Unable to load photo")
                }
                cell.img.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopInventoryCell", for: indexPath) as! ShopInventoryCell
    }
}
