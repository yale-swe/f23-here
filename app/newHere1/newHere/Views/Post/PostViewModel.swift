//
//  PostViewModel.swift
//  newHere
//
//  Created by Liyang Wang on 2023/11/30.
//

import SwiftUI

class PostViewModel: ObservableObject {
    
    @Published var noteMessage: String

    @Published var isPresented: Bool

    @State var userId =  UserDefaults.standard.string(forKey: "UserId") ?? ""
    @State var timeoutInterval: TimeInterval = 20.0

    @State var isEditing = false

    @Published var messageState: MessageState
    
    let locationDataManager: LocationDataManager
    
    init(noteMessage: String = "", isPresented: Bool, isEditing: Bool = false, messageState: MessageState, locationDataManager: LocationDataManager) {
        self.noteMessage = noteMessage
        self.isPresented = isPresented
        self.isEditing = isEditing
        self.messageState = messageState
        self.locationDataManager = locationDataManager
    }
    
    func postMessage() {
        newHere.postMessage(user_id: self.userId, text: noteMessage, visibility: "friends", locationDataManager: locationDataManager, timeoutInterval: timeoutInterval) {
            result in
            switch result {
            case .success(let response):
                print("Message posted successfully: \(response)")
                
                do {
                    let newMessage = try Message(
                        id: response._id,
                        user_id: self.userId,
                        location: response.location.toCLLocation(),
                        messageStr: response.text,
                        visibility: "Public")
                    // Use newMessage here
                    //                                                    self.storedMessages.append(newMessage)
                    
                    // Update messageState with the new message
                    self.messageState.currentMessage = newMessage
                    
                } catch {
                    // Handle the error
                    print("Error: \(error)")
                }
                
                
            case .failure(let error):
                print("Error posting message: \(error.localizedDescription)")
            }
            
            self.isPresented.toggle()
        }
    }
}
