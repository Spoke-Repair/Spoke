//
//  OpenOrderCollectionView.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 12/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

var BikeDescriptionList = [String]() //contains the work orders description of what needs to be done to the bike
var WorkOrderIDList = [String]() //contains the ID of the WorkOrder Objects
var BikeIDList = [String]() //contains the BikeID taken from the bikeID column of the WorkOrders Table
var BikeOwnersList = [String]() //contains the userID of the bikeOwner found from looking up the BikeID from the Work Orders table
var StoreOwnerID: String = "" //this is just the store owners userID which is also the current users ID in this class
var MyIndex = 0

var BikeList = [BikeObject]()

class OpenOrderCollectionView: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var bikesDueLabel: UILabel!
    @IBOutlet var currentDate: UILabel!
    @IBOutlet var bikeCollectionView: UICollectionView!
    
    @IBOutlet var nextBikeLabel: UILabel!
    var bikesDue = 0

    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)

        self.currentDate.text = result

        //get the Store owners ID for later use in chat
        StoreOwnerID = (PFUser.current()?.objectId)!

        BikeDescriptionList.removeAll()
        WorkOrderIDList.removeAll()
        BikeOwnersList.removeAll()
        BikeIDList.removeAll()

        self.bikesDue = 0

        let query = PFQuery(className: "WorkOrders")
        query.whereKey("isOpen", equalTo: "open")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        BikeDescriptionList.append(object["description"] as! String)
                        BikeIDList.append(object["bikeID"] as! String)
                        WorkOrderIDList.append(object.objectId!)
                        let bikeDate = object["dueDate"] as! String
                        if bikeDate == result {
                            self.bikesDue += 1
                        }

                        // bikeOwnersList.append(object["userID"] as! String)
                        //here query to get the bike object based on the objectID to get the bike owners ID
                        let bikeUserQuery = PFQuery(className: "Bike")
                        bikeUserQuery.whereKey("objectId", equalTo: object["bikeID"])
                        //execute query to find the userID of the bike
                        bikeUserQuery.findObjectsInBackground(block: { (bikeObjects: [PFObject]?, bikeError: Error?) in
                            if bikeError == nil {
                                if let bikeObjects = bikeObjects {
                                    for object in bikeObjects {
                                        //we have the bike were looking for so get the user of the Bikes id

                                        let make = object["make"] as! String
                                        let model = object["model"] as! String
                                        let isOwned = object["userID"] != nil
                                        let size = object["size"] as! String
                                        let userId = object["userID"] as! String
                                        let bikeId = object.objectId!
                                        let bikeToAdd: BikeObject = BikeObject(make: make, model: model, size: size, isOwned: isOwned, userId: userId, bikeId: bikeId)

                                        if let picture = object["picture"] {
                                            let pImage = picture as! PFFile
                                            pImage.getDataInBackground(block: { (data: Data?, error: Error?) in
                                                if let imageToSet = UIImage(data: data!) {
                                                    bikeToAdd.picture = imageToSet
                                                    print("Got image")
                                                    // self.tableView.reloadData()
                                                    self.bikeCollectionView.reloadData()
                                                }
                                            })
                                        }
                                        BikeList.append(bikeToAdd)
                                        BikeOwnersList.append(object["userID"] as! String)
                                    }
                                }
                            }
                        })
                    }
                    // self.theTable.reloadData()
                    self.bikeCollectionView.reloadData()
                }
            }else{
                print("An error occured finding work orders")
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        self.bikesDueLabel.text = "You have \(bikesDue) orders due today"
        self.nextBikeLabel.text = "Next bike for repair: \(BikeList[0].make)"
        // CommonUtils.addFCMTokenToParse()
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myIndex = indexPath.row
        self.performSegue(withIdentifier: "openOrderSegue", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (BikeList.count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BikeOrderCollection", for: indexPath) as! BikeOrderCell
        print("The cell label: \(BikeList[indexPath.row].make)")
        cell.textLabel.text = BikeList[indexPath.row].make
        //set the color
        switch((indexPath.row) % 4) {
            
        case 1:
            print("CASE 1")
            cell.contentView.backgroundColor = UIColor(displayP3Red: 237/255, green: 248/255, blue: 245/255, alpha: 1.0)
            
        case 2:
            print("CASE 2")
            cell.contentView.backgroundColor = UIColor(displayP3Red: 255/255, green: 243/255, blue: 244/255, alpha: 1.0)
            
        case 3:
            print("CASE 3")
            cell.contentView.backgroundColor = UIColor(displayP3Red: 253/255, green: 251/255, blue: 245/255, alpha: 1.0)
            
        default:
            print("CASE default")
            cell.contentView.backgroundColor = UIColor(displayP3Red: 237/255, green: 248/255, blue: 245/255, alpha: 1.0)
        }
        return cell
    }
}
