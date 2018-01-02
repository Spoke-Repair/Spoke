//
//  BikeObject.swift
//  ParseStarterProject-Swift
//
//  Created by Garrett Huff on 11/6/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import UIKit

class BikeObject {
    
    var make: String
    var model: String
    var size: String
    var picture: UIImage? = nil
    var isOwned: Bool
    var userId: String
    var bikeId: String
    
    
    init(make: String, model: String, size: String, isOwned: Bool, userId: String, bikeId: String ){
        self.make = make
        self.model = model
        self.size = size
        self.isOwned = isOwned
        self.userId = userId
        self.picture = nil
        self.bikeId = bikeId
    }
    
    init(make: String, model: String, size: String, isOwned: Bool, userId: String, bikeId: String, picture: UIImage ){
        self.make = make
        self.model = model
        self.size = size
        self.isOwned = isOwned
        self.userId = userId
        self.picture = picture
        self.bikeId = bikeId
    }
    
    func doesPictureExist() -> Bool {
        return self.picture != nil
    }
}
