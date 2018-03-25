//
//  FrameWorkExtensions.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/25/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import Parse

//https://gist.github.com/DamienBell/ea40da87cfc568e7956d6f6d264e84ed
extension PFObject {
    override open var hashValue : Int {
        get {
            return self.objectId?.hashValue ?? 0
        }
    }
    
    override open func isEqual(_ other: Any?) -> Bool {
        if self.objectId == (other as? PFObject)?.objectId {
            return true
        }
        else {
            return super.isEqual(other)
        }
    }
}
