//
//  Message.swift
//  newHere
//
//  Created by Eric Wang on 10/28/23.
//

import Foundation
import CoreLocation

class Message {
    var location: CLLocation
    var author: String
    var messageStr: String
    
    init(location:CLLocation, author: String, messageStr: String) {
        self.location = location
        self.author = author
        self.messageStr = messageStr
    }
    
    func displayMessage() -> String {
        return "Author: \(author)\n\(location.coordinate.latitude.description), \(location.coordinate.longitude.description), \n\(messageStr)"
    }
}
