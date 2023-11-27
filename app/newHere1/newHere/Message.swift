//
//  Message.swift
//  newHere
//
//  Created by Eric Wang on 10/28/23.
//

import Foundation
import CoreLocation

class Message {
    var id: String
    var user_id: String
//    var username: String
    var location: CLLocation
    var messageStr: String
    
    init(id:String, user_id: String, location:CLLocation, messageStr: String) {
        self.id = id
        self.user_id = user_id
        self.location = location
        self.messageStr = messageStr
    }
}
