//
//  CommonUtils.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Alamofire
import Parse
import UIKit

/*
 This is a class for helper util methods
*/
class CommonUtils {
    
    enum ConnectionResult {
        case success()
        case failure()
    }
    
    static func popUpAlert(message: String, sender: UIViewController) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        sender.present(alertController, animated: true, completion: nil)
        
    }
    
    static func strip(from number: String, characters: [String]) -> String {
        var newNumber = number
        for char in characters {
            newNumber = newNumber.replacingOccurrences(of: char, with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        return newNumber
    }
    
}
