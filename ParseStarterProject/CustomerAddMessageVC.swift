//
//  CustomerAddMessageVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/5/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class CustomerAddMessageVC: UIViewController {

    @IBOutlet var messageField: UITextField!
    
    
    @IBAction func submitCustomerMessage(_ sender: Any) {
        
        if (validateFields()) {
            //make the Message Object
            let messageObject = PFObject(className: "OrderMessages")
            messageObject["bikeID"] = customerBikeIDList[customerIndex]
            messageObject["message"] = messageField.text
            messageObject["UserType"] = "customer"
            messageObject["UserID"] = PFUser.current()?.objectId
            messageObject.saveInBackground(block: { (bool: Bool, error: Error?) in
                
                if error == nil {
                    print("Saved message from customer")
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    print("Error saving message from customer")
                }
                
            })
            
            
            
            
            
            
            
        }else{
            print("Enter a message idiot")
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomerAddMessageVC.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateFields() -> Bool {
        if messageField.text != nil && messageField.text != "" {
            return true
        }
        
        return false
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
