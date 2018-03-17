//
//  CustomerCheckoutVC.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 3/11/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import Parse

/*
 add this extension to the last view controller in the flow where the customer submits the request. If they dont have a stripe ID saved in their corresponding user entry in the table, you want to initialize this extension to show the payment info
 */
extension CustomerCheckoutVC: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        
        completeCharge(with: token, amount: 6000) { result in
            switch result{
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Thanks!",
                                                        message: "Your payment info was saved!",
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
            
        }
        
    }
    
    
}


class CustomerCheckoutVC: UIViewController {
    //implement this function according to pseudocode
    //action for when customer submits their request
    @IBAction func continueToPayment(_ sender: Any) {
        /*
         psuedocode:
         if(ParseUser.stripeID == nil) {
         //no payment on file so we need to create a customer in the stripe database by calling the code below that is not commented out. Note: we can swap out the method that that code calls which right now is the completeCharge method that needs a name change of course
         
         create parse work order with customer info so we can track the order in parse and stripe
         }else{
         //we already have the persons info so first verify it to make sure its right
         retrieveCustomer(parseuser.stripeID)
         if retrieveCustomer is True {
         
         createParseWorkOrder
         
         }
         else{
         show error message, present the other controller to get updated payment info
         //save the new key to the user table so we can look it up next time
         //create the parse work order
         }
         
         }
         
         */
        
        //this is how you show the stripe view controller to add the card
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        self.navigationController?.pushViewController(addCardViewController, animated: true)
        
    }
    
    /*
     Function to create a customer in stripe database
     need to add: send parse first and last name and maybe email to stripe to create object or a description to trace back to parse
     will return: a customer object, but im not sure how to get that object from response. We need to save the customerID to a column in the user table so that we can look them up in the future
     */
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result<Any>) -> Void) {
        
        //this is how to call a rest call to our Parse Cloud code in cloud/main.js
        PFCloud.callFunction(inBackground: "saveCustomer", withParameters: ["token" : token.tokenId, "amount": amount, "currency": "usd", "description": "Payment for bike repair"]){ (response: Any?, error: Error?) in
            //if 200 OK
            if(error == nil) {
                completion(Result.success("Created Customer success!"))
                //if anything else will come back as 400 Failure
            }
            else {
                completion(Result.failure(error!))
            }
            
        }
        
    }
    //use this function to verify if a customer exists
    //right now stripeRetrieve function in cloud.js has hardcoded vals
    func retrieveCustomer(with token: STPToken, stripeID: String, completion: @escaping (Result<Any>) -> Void) {
        
        //this is how to call a rest call to our Parse Cloud code in cloud/main.js
        PFCloud.callFunction(inBackground: "stripeRetreive", withParameters: ["token" : token.tokenId, "stripeID": stripeID]){ (response: Any?, error: Error?) in
            //if 200 OK
            if(error == nil) {
                completion(Result.success("Customer Exists"))
                //if customer doesnt exist will come back as 400 Failure
            }
            else {
                completion(Result.failure(error!))
            }
        }
    }
}


