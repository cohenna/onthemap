//
//  StudentLocation.swift
//  On the Map
//
//  Created by Nick Cohen on 5/23/15.
//  Copyright (c) 2015 Nick Cohen. All rights reserved.
//

import Foundation
class StudentLocation : NSObject {
    var objectId : String?
    var uniqueKey : String?
    var firstName : String?
    var lastName : String?
    var mapString : String?
    var mediaURL : String?
    var latitude : Double?
    var longitude : Double?
    //var createdAt : Date?
    //var updatedAt : Date?
    //ACL
    
    override init() {
        super.init()
    }
    
    init(fromJSON: AnyObject?) {
        if let result = fromJSON as AnyObject? {
            objectId = result.valueForKey("objectId") as! String?
            uniqueKey = result.valueForKey("uniqueKey") as! String?
            firstName = result.valueForKey("firstName") as! String?
            lastName = result.valueForKey("lastName") as! String?
            mapString = result.valueForKey("mapString") as! String?
            mediaURL = result.valueForKey("mediaURL") as! String?
            latitude = result.valueForKey("latitude") as! Double?
            longitude = result.valueForKey("longitude") as! Double?
        }
        
    }
}