//
//  MockMessageState.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/27/23.
//

import Foundation
import CoreLocation
@testable import newHere

class MockMessageState: MessageState{
    var messages: [Message] = []
    init(messages: [Message] = []) {
        self.messages = messages
    }
    
    func addMessage(_ message: Message) {
        messages.append(message)
    }
    
    func deleteMessage(withId id: String) {
        messages.removeAll { $0.id == id }
    }
    
    func findMessage(withId id: String) -> Message? {
        return messages.first { $0.id == id }
    }
    
    func updateMessage(withId id: String, newMessage: Message) {
        if let index = messages.firstIndex(where: { $0.id == id }) {
            messages[index] = newMessage
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    
    class Message {
        var id: String
        var user_id: String
        var location: CLLocation
        var messageStr: String
        
        init(id: String, user_id: String, location: CLLocation, messageStr: String) {
            self.id = id
            self.user_id = user_id
            self.location = location
            self.messageStr = messageStr
        }
    }
}
