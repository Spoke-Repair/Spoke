//
//  WorkListObject.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 8/21/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation

class WorkListObject {
    
    var service: String
    var price: Double
    
    init(service: String, price: Double) {
        self.service = service
        self.price = price
    }
    
}
