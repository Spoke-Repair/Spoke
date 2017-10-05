//
//  AddBikeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class AddBikeViewController: UIViewController {

    @IBOutlet var makeLabel: UITextField!
    
    @IBOutlet var modelLabel: UITextField!
    
    @IBOutlet var idLabel: UITextField!
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    //go to backToMyBikes segue
        self.performSegue(withIdentifier: "backToMyBikes", sender: self)
    }
    
    @IBAction func goToScanner(_ sender: Any) {
    
        self.performSegue(withIdentifier: "scanQRSegue", sender: self)
    }
    
    @IBAction func submitBikeToDB(_ sender: Any) {
        /*
        if makeLabel.text != nil && modelLabel.text != nil && idLabel.text != nil {
            
            let newBike = PFObject(className: "Bike")
            newBike["make"] = makeLabel.text
            newBike["model"] = modelLabel.text
            newBike["bikeID"] = idLabel.text
            newBike["userID"] = PFUser.current()?.objectId
            newBike.saveInBackground(block: { (success: Bool, Error) in
                if(success){
                    let alert = UIAlertController(title: "Done", message: "You added a new bike", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }else {
                    let alert = UIAlertController(title: "Error", message: "something went wrong...", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
            })
            
        }*/
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddBikeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "scanQRSegue" {
            print("HAHAHAHHA")
            if makeLabel.text != nil && modelLabel.text != nil && idLabel.text != nil {
                if let addBikeVC = segue.destination as? AddBikeScannerVC {
                    addBikeVC.make = makeLabel.text
                    addBikeVC.model = modelLabel.text
                    addBikeVC.type = idLabel.text
                }
            }
        }else if segue.identifier == "backToMyBikes" {
            let navVC = segue.destination as? UINavigationController
            let vc = navVC?.viewControllers.first as! BikeListController
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
