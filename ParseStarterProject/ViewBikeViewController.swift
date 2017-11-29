//
//  ViewBikeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/5/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ViewBikeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var bikePicture: UIImageView!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var testLabel: UILabel!
    var messages = [String]()
    var messagesType = [String]() //ether employee or customer and corresponds to the message with the same index
    var messageDates = [String]()
    @IBOutlet var makeLabel: UILabel!
    
    @IBOutlet var messagesTableView: UITableView!
    
    @IBAction func addMessageFromCustomer(_ sender: Any) {
        self.performSegue(withIdentifier: "customerCreateMessage", sender: self)    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bikePicture.layer.cornerRadius = self.bikePicture.frame.size.width / 2
        self.bikePicture.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //testLabel.text = customerBikeIDList[customerIndex]
        print("PRINTING CUSTOMER INDEX: \(customerIndex)")
        self.makeLabel.text = bikeObjectList[customerIndex].make
        self.modelLabel.text = bikeObjectList[customerIndex].model
        
        if bikeObjectList[customerIndex].doesPictureExist() {
            if let picture = bikeObjectList[customerIndex].picture {
                self.bikePicture.image = picture
            }
                
            
            
        }
        
        
        
        messages.removeAll()
        messagesType.removeAll()
        let query = PFQuery(className: "OrderMessages")
        
        query.whereKey("bikeID", equalTo: bikeObjectList[customerIndex].bikeId)
        query.findObjectsInBackground(block: { (messageObjects: [PFObject]?, error: Error?) in
            if error == nil {
                if let messageObjects = messageObjects {
                    for messageObect in messageObjects {
                        let txt = messageObect["message"] as! String
                        self.messages.append(txt)
                        self.messagesType.append(messageObect["UserType"] as! String)
                        //print("Found message: "+(messageObect["message"] as! String))
                        let date = messageObect.createdAt
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
                        let formattedDate = dateFormatter.string(from: date!)
                        self.messageDates.append(formattedDate)
                        
                    }
                    self.messagesTableView.reloadData()
                }
            }
        })
        
        self.messagesTableView.reloadData()
    
    
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.messages.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messagesType[indexPath.row] == "employee" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "customerSideMessageCell", for: indexPath) as! CustomerViewMessageCell
            
            cell.messageLabel.text = self.messages[indexPath.row]
            cell.dateLabel.text = self.messageDates[indexPath.row]
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customerSideCustomerCell", for: indexPath) as! CustomerViewCusMessageCell
            
            cell.messageLabel.text = self.messages[indexPath.row]
            cell.dateLabel.text = self.messageDates[indexPath.row]
            
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
