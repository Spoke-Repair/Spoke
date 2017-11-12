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
var indicator = UIActivityIndicatorView()


var bikeObjectList = [BikeObject]()


class BikeListController: UITableViewController {


    @IBAction func addBike(_ sender: Any) {
       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "addBikeVC")
        //self.present(vc, animated: true, completion: nil)
       self.performSegue(withIdentifier: "addBike", sender: self)
    }
    
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //associate user to this device for notification usage
        CommonUtils.addFCMTokenToParse()
        activityIndicator()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //was func viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        //disable touch while the tableview is loading
        self.view.isUserInteractionEnabled = false
        
        bikeObjectList.removeAll()
        
        let query = PFQuery(className: "Bike")
        if let userID = PFUser.current()?.objectId {
            print("user ID: "+userID)
            query.whereKey("userID", equalTo: userID)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            //print("printing items from parse query")
                            //print(object["userID"])
                            //print(object["model"])
                            let make = object["make"] as! String
                            let model = object["model"] as! String
                            let isOwned = object["isOwned"] as! Bool
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
                                        self.tableView.reloadData()
                                    }
                                    
                                })
                            
                            }
                            /*
                            if(!(bikeList.contains(object["model"] as! String))){
                                //bikeList.append(object["model"] as! String)
                                //customerBikeIDList.append(object.objectId!)
                            }*/
                            
                                bikeObjectList.append(bikeToAdd)
                                print("ADDED BIKE TO LIST")
                            
                            
                        }
                        self.tableView.reloadData()
                        self.view.isUserInteractionEnabled = true
                        indicator.stopAnimating()
                        indicator.hidesWhenStopped = true

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
        return (bikeObjectList.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BikeListCell
        let cell = Bundle.main.loadNibNamed("BikeCellX", owner: self, options: nil)?.first as! BikeCellX
        
        //cell.bikeText.text = bikeList[indexPath.row]
        cell.bikeText.text = bikeObjectList[indexPath.row].make
        // Configure the cell...
       if(bikeObjectList[indexPath.row].doesPictureExist()){
            cell.bikeImage.image = bikeObjectList[indexPath.row].picture
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        customerIndex = indexPath.row
        self.performSegue(withIdentifier: "customerViewBike", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBike" {
            let navVC = segue.destination as? UINavigationController
            _ = navVC?.viewControllers.first as! AddBikeViewController
        }
    }
 
}
