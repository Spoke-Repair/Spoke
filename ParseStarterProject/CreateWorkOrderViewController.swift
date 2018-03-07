//
//  CreateWorkOrderViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/16/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class CreateWorkOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bikeID: String? = nil
    let workOrderList = WorkListValues()
    
    @IBOutlet var issueDescription: UITextField!
    @IBOutlet var dueDate: UITextField!
    var userID: String? = nil
    
    @IBAction func submitOrder(_ sender: Any) {
        print("THe bike ID: " + bikeID!)
               //new object here
        let newOrder = PFObject(className: "WorkOrders")
        newOrder["bikeID"] = bikeID
        newOrder["description"] = issueDescription.text
        newOrder["dueDate"] = dueDate.text
        newOrder["isOpen"] = "open"
        newOrder.saveInBackground { (success: Bool, error: Error?) in
            if(success){
                print("Saved new object")
                //self.performSegue(withIdentifier: "backToOrders", sender: self)
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc : UITabBarController = storyboard.instantiateViewController(withIdentifier: "shopTabBarController") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
            
            
            }else {
                print("An error occured")
            }
        }
        
        
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allowHideKeyboardWithTap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToOrders" {
          //  let navVC = segue.destination as? UINavigationController
            //_ = navVC?.viewControllers.first as! OpenOrderCollectionView
            //this needs to be unwind??
            
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workOrderList.listOfServices.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath) as! AvailableServiceCell
        
        cell.serviceName.text = workOrderList.listOfServices[indexPath.row].service
        cell.servicePrice.text = workOrderList.listOfServices[indexPath.row].price.description
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
