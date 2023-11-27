//
//  Message.swift
//  newHere
//
//  Created by Eric Wang on 10/28/23.
//

// Description:  This class represents a message object, including its unique identifier, associated user ID, geographic location, and message content.

//Properties:
//- id: A unique identifier for the message.
//- user_id: The user ID of the sender associated with the message.
//- location: A CLLocation object representing the geographic location associated with the message.
//- messageStr: The string content of the message.
//
//Initializer:
//- Initializes a new Message object with the provided parameters.
//
//Note: This class is utilized for managing messages within the application and may be used in conjunction with location-based features.

import Foundation
import CoreLocation

class Message {
    var id: String
    var user_id: String
//    var username: String
    var location: CLLocation
    var messageStr: String
    
    // Initialize Message object with provided parameters
    init(id:String, user_id: String, location:CLLocation, messageStr: String) {
        self.id = id
        self.user_id = user_id
        self.location = location
        self.messageStr = messageStr
    }
}
