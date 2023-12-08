import Foundation
import CoreLocation


/**
 * Message Class
 *
 * A class representing a message with identifiers, location, and content.
 *
 * Properties:
 * - id: String for message ID.
 * - user_id: String for user ID.
 * - location: CLLocation for geographical location.
 * - messageStr: String for message content.
 *
 * Initialization:
 * - Initializes with id, user_id, location, and messageStr.
 */
class Message {
    var id: String
    var user_id: String
//    var username: String
    var location: CLLocation
    var messageStr: String
    var visibility: String
    
    /// Initialize Message object with provided parameters
    init(id:String, user_id: String, location:CLLocation, messageStr: String, visibility: String) {
        self.id = id
        self.user_id = user_id
        self.location = location
        self.messageStr = messageStr
        self.visibility = visibility
    }
}
