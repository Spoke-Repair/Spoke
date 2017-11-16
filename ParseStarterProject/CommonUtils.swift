//
//  CommonUtils.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 10/17/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import Alamofire
import Parse
import FirebaseInstanceID
import FirebaseMessaging
/*
 This is a class for helper util methods
*/
class CommonUtils {
    
    /*
     Use this method once a user is logged in to associate the device with their account
     */
    static func addFCMTokenToParse() {
        let user = PFUser.current()!
        if let token = Messaging.messaging().fcmToken {
            if token != "" {
                print("IN OpenOrders FCM is: \(token)")
                user["FCM"] = token
                user.saveInBackground(block: { (bool: Bool, error: Error?) in
                    if error == nil {
                        print("Added users FCM Token")
                    }else{
                        print("An error occured saving FCM token")
                    }
                    
                })
                
                
            }
            
        }
    }
    /*
     Helper method to sendMessage in order to look up the current users information,
     then call sendMessage to actually send a notification to the found user
     PARAMS: userID -> This is the parse users ID, taken from the Parse table Users and the column objectId
             message -> A message that you want to send as a notification to the user
     */
    static func sendMessageToParseUser(userID: String, message: String) {
        
        let query = PFUser.query()
        query?.whereKey("objectId", equalTo: userID)
        query?.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                print("Got the bike user in ViewOrder INfoView Controller")
                if let objects = objects {
                    if let userFcmToken = objects[0]["FCM"]{
                        print("Got the users FCM")
                        let prettyToken = userFcmToken as! String
                        CommonUtils.sendMessage(DEVICEID: prettyToken, message: message)
                    }else{
                        print("COULD NOT GET TOKEN FROM PARSE!!!!!")
                    }
                }
                
                
            }
        })
        
        
    }
    
    /*
     Method used to send a message to a user denoted by there FCM token. Call sendMessageToParseUser
     in order to invoke this method properly (white an FCM token that you do not know :) )
     */
    static func sendMessage(DEVICEID: String, message: String) {
        let serverKey = "AAAAMTi-Z3c:APA91bGk5_WHAL8vcjQrioTwgp5BPoijebnMQAr1Ra7SnGiDYiE5-tqAyE4X4zpI34keiQzoG6V1uJ94QY6XigmnIhlvMvqeR7AXmYUw6zl80ani3lEqxc2pceyrm9orqqBQZAWOHKcF"
        var _headers: HTTPHeaders? = HTTPHeaders()
        let endPoint = "https://fcm.googleapis.com/fcm/send"

        
        _headers =
            [
                "Content-Type": "application/json",
                "Authorization": "key=\(serverKey)"
        ]
        
        let _notifications: Parameters? = [
            
            "to": "\(DEVICEID)",
            "notification": [
                "body": "\(message)",
                "title": "Urabo"
            ]
        ]
        
        _ = Alamofire.request(endPoint as URLConvertible, method: .post as HTTPMethod, parameters: _notifications, encoding: JSONEncoding.default, headers: _headers!)
            .responseJSON(completionHandler: { (resp) in
                print(resp)
            })
        
        
    }
    
    static func popUpAlert(message: String, sender: UIViewController) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        sender.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
}
