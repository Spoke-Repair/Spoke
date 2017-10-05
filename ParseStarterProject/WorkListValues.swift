//
//  WorkListValues.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

class WorkListValues {
    
    var listOfServices = [WorkListObject]()
    
    init(){
        
        listOfServices.append(WorkListObject(service: "Basic Tune-Up", price: 59.99))
        listOfServices.append(WorkListObject(service: "Bicycle Detail", price: 49.99))
        listOfServices.append(WorkListObject(service: "Major Tune Up", price: 79.99))
        listOfServices.append(WorkListObject(service: "The Works", price: 149.99))
        listOfServices.append(WorkListObject(service: "Derailleur Adjust Front", price: 11.99))
        
        
    }
    
    
}
