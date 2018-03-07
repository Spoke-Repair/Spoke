//
//  CreateOrderViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ViewOrderInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var makeLabel: UILabel!
    
    @IBOutlet var modelLabel: UILabel!
    var messages = [String]()
    var messageDates = [String]()
    var messageType = [String]()
    var currentUser = (PFUser.current()?.objectId)!
    
    @IBOutlet var theTableView: UITableView!
    
    @IBAction func closeButton(_ sender: Any) {
        //var objectID = bikeObjectList[myIndex]
        //send message to customer
        CommonUtils.sendMessageToParseUser(userID: bikeOwnersList[myIndex], message: "Your bike is ready for pickup!")
        //close the order
        
    }
    @IBAction func addMessage(_ sender: Any) {
        self.performSegue(withIdentifier: "addMessageSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeLabel.text = BikeList[myIndex].make
        self.modelLabel.text = BikeList[myIndex].model
        
        // theLabel.text = BikeList[myIndex].userId
        //objectLabel.text = BikeList[myIndex].bikeId
        //currentUser.text = storeOwnerID
        //bikeOwner.text = BikeList[myIndex].userId
        //bikeID.text = BikeList[myIndex].userId
        
        
        
        
        // Do any additional setup after loading the view.
        self.theTableView.reloadData()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        messages.removeAll()
        
        let query = PFQuery(className: "OrderMessages")
        
        //query.whereKey("StoreUserID", equalTo: storeOwnerID ).whereKey("userID", equalTo: bikeOwnersList[myIndex])
        query.whereKey("bikeID", equalTo: BikeList[myIndex].bikeId)
        query.findObjectsInBackground(block: { (messageObjects: [PFObject]?, error: Error?) in
            if error == nil {
                if let messageObjects = messageObjects {
                    for messageObect in messageObjects {
                        let txt = messageObect["message"] as! String
                        let date = messageObect.createdAt!
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
                        let formattedDate = dateFormatter.string(from: date)
                        
                        self.messages.append(txt)
                        self.messageDates.append(formattedDate)
                        self.messageType.append(messageObect["UserType"] as! String)
                        //print("Found message: "+(messageObect["message"] as! String))
                        
                    }
                    self.theTableView.reloadData()
                }
            }
        })
        
        self.theTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.messages.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messageType[indexPath.row] == "employee"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
            
            cell.messageLabel.text = self.messages[indexPath.row]
            cell.dateLabel.text = self.messageDates[indexPath.row]
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customerMessageCell", for: indexPath) as! CustomerMessageCell
            
            cell.messageLabel.text = self.messages[indexPath.row]
            cell.dateLabel.text = self.messageDates[indexPath.row]
            
            return cell
        }
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "addMessageSegue" {
            let addMessageController = segue.destination as! AddMessageFromStoreVC
            //force unwrap because we have already validated with validateFieldFunction
            addMessageController.bikeID = BikeList[myIndex].bikeId
            addMessageController.bikeOwnerID = BikeList[myIndex].userId
            addMessageController.storeID = self.currentUser
        }
    }
}
