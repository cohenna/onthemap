//
//  UdacityUser.swift
//  On the Map
//
//  Created by Nick Cohen on 5/22/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation

class UdacityUser {
    var firstName = ""
    var lastName = ""
    var id = ""
    
    init(fromJSON: AnyObject?) {
        if let result = fromJSON as AnyObject? {
            var user = result.valueForKey("user") as! [String : AnyObject]
            firstName = user["first_name"] as! String
            lastName = user["last_name"] as! String
            id = user["key"] as! String
        }
        
    }
}