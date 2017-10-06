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

    @IBOutlet var testLabel: UILabel!
    var messages = [String]()
    var messagesType = [String]() //ether employee or customer and corresponds to the message with the same index
    
    @IBOutlet var messagesTableView: UITableView!
    
    @IBAction func addMessageFromCustomer(_ sender: Any) {
        self.performSegue(withIdentifier: "customerCreateMessage", sender: self)    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //testLabel.text = customerBikeIDList[customerIndex]
        messages.removeAll()
        messagesType.removeAll()
        let query = PFQuery(className: "OrderMessages")
        
        query.whereKey("bikeID", equalTo: customerBikeIDList[customerIndex])
        query.findObjectsInBackground(block: { (messageObjects: [PFObject]?, error: Error?) in
            if error == nil {
                if let messageObjects = messageObjects {
                    for messageObect in messageObjects {
                        let txt = messageObect["message"] as! String
                        self.messages.append(txt)
                        self.messagesType.append(messageObect["UserType"] as! String)
                        //print("Found message: "+(messageObect["message"] as! String))
                        
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
        
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "bikeMessagesCustomer")
        let cell2 = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "bikeMessagesCustomer")
        //test
        if self.messagesType[indexPath.row] == "employee"{
            cell2.textLabel?.text = "Employee test: " + self.messages[indexPath.row]
            return cell2
        }
        
        cell.textLabel?.text = "Customer message: " + self.messages[indexPath.row]
        
        
        return cell
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
