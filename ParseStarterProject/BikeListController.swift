//
//  BikeListController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse


var bikeList = [String]()
var customerBikeIDList = [String]()
var customerIndex: Int = 0;

class BikeListController: UITableViewController {

    
    @IBAction func addBike(_ sender: Any) {
       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "addBikeVC")
        //self.present(vc, animated: true, completion: nil)
       self.performSegue(withIdentifier: "addBike", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       //associate user to this device for notification usage
        CommonUtils.addFCMTokenToParse()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //was func viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        let query = PFQuery(className: "Bike")
        if let userID = PFUser.current()?.objectId {
            print("user ID: "+userID)
            query.whereKey("userID", equalTo: userID)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            print("printing items from parse query")
                            print(object["userID"])
                            print(object["model"])
                            if(!(bikeList.contains(object["model"] as! String))){
                                bikeList.append(object["model"] as! String)
                                customerBikeIDList.append(object.objectId!)
                            }
                        }
                        self.tableView.reloadData()

                    }
                }else {
                    //there was an error
                    print("There was an error...")
                }
            })
            
        }
        
    }
    
    //no reason for having this function here other then idk
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (bikeList.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BikeListCell
        cell.theText.text = bikeList[indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        customerIndex = indexPath.row
        self.performSegue(withIdentifier: "customerViewBike", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBike" {
            let navVC = segue.destination as? UINavigationController
            let vc = navVC?.viewControllers.first as! AddBikeViewController
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
