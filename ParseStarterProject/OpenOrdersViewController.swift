//
//  OpenOrdersViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

//set as global so that we can access these fields in the next view

var bikeDescriptionList = [String]() //contains the work orders description of what needs to be done to the bike
var workOrderIDList = [String]() //contains the ID of the WorkOrder Objects
var bikeIDList = [String]() //contains the BikeID taken from the bikeID column of the WorkOrders Table
var bikeOwnersList = [String]() //contains the userID of the bikeOwner found from looking up the BikeID from the Work Orders table
var storeOwnerID: String = "" //this is just the store owners userID which is also the current users ID in this class
var myIndex = 0

class OpenOrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet var theTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get the Store owners ID for later use in chat
        storeOwnerID = (PFUser.current()?.objectId)!
        
        bikeDescriptionList.removeAll()
        workOrderIDList.removeAll()
        bikeOwnersList.removeAll()
        bikeIDList.removeAll()
        
        let query = PFQuery(className: "WorkOrders")
        query.whereKey("isOpen", equalTo: "open")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        bikeDescriptionList.append(object["description"] as! String)
                        bikeIDList.append(object["bikeID"] as! String)
                        workOrderIDList.append(object.objectId!)
                        
                        // bikeOwnersList.append(object["userID"] as! String)
                        //here query to get the bike object based on the objectID to get the bike owners ID
                        let bikeUserQuery = PFQuery(className: "Bike")
                        bikeUserQuery.whereKey("objectId", equalTo: object["bikeID"])
                        //execute query to find the userID of the bike
                        bikeUserQuery.findObjectsInBackground(block: { (bikeObjects: [PFObject]?, bikeError: Error?) in
                            
                            if bikeError == nil {
                                
                                if let bikeObjects = bikeObjects {
                                    for bike in bikeObjects {
                                        //we have the bike were looking for so get the user of the Bikes id
                                        bikeOwnersList.append(bike["userID"] as! String)
                                        
                                    }
                                }
                            }
                            
                        })
                        
                        
                        
                        
                    }
                    self.theTable.reloadData()
                }
            }else{
                print("An error occured finding work orders")
            }
            
        })
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bikeDescriptionList.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "openOrderCell")
        cell.textLabel?.text = bikeDescriptionList[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        self.performSegue(withIdentifier: "openOrderSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
             let query = PFQuery(className: "WorkOrders")
            query.whereKey("objectId", equalTo: workOrderIDList[indexPath.row])
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground(block: { (bool: Bool, error: Error?) in
                            
                            bikeIDList.remove(at: indexPath.row)
                            workOrderIDList.remove(at: indexPath.row)
                            bikeDescriptionList.remove(at: indexPath.row)
                            bikeOwnersList.remove(at: indexPath.row)
                            self.theTable.reloadData()
                        
                        })
                    }
                }
                
            })
            
        }
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
