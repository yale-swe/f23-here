import SwiftUI
import CoreLocation
import Foundation

/**
 * PostsPopup
 *
 * A SwiftUI view component for creating and posting messages. It offers an interactive interface for users to write and share posts.
 * The view uses a binding variable to control its visibility and environment objects for state and location data management.
 *
 * Features:
 * - TextEditor for message input.
 * - Share and Post buttons for user interaction.
 * - GeometryReader and ZStack for dynamic, layered UI layout.
 * - Integration with location data and message state for post creation.
 *
 * Note:
 * - It includes a close button to dismiss the view and leverages environment objects like `messageState` and `locationDataManager`.
 */
struct PostsPopup: View {
    @Binding var isPresented: Bool
    //    @Binding var storedMessages: [Message]
    
    @State var noteMessage: String = ""
    @State var isEditing = false
    
    var messageState: MessageState
    
    let senderName: String = "Username"
    
    var locationDataManager: LocationDataManager
    
    

    var body: some View {
        // GeometryReader for dynamic layout based on screen size
        GeometryReader { geometry in
            // ZStack for layering views
            ZStack {
                Color.clear.edgesIgnoringSafeArea(.all) // Transparent background
                // VStack for vertical arrangement of UI elements
                VStack(spacing: 10) {
                    Spacer()
                
                    // ZStack for styling the message input area
                    ZStack {
                        // RoundedRectangle and TextEditor ZStack
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.0)) // Adjust the opacity to your preference
                            .frame(width: geometry.size.width - 40, height: geometry.size.width - 40)
                            .shadow(radius: 5)
                        
                        // VStack for arranging TextEditor and buttons vertically
                        VStack {
                            ZStack(alignment: .leading) {
                                if noteMessage.isEmpty && self.isEditing == false {
                                    Text("Leave a message here")
                                        .foregroundColor(.gray)
                                        .padding(.all, 30)
                                }
                                TextEditor(text: $noteMessage)
                                    .onTapGesture {
                                        self.isEditing = true
                                    }
                                    .padding(.all, 30)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .foregroundColor(Color.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)
                            
                            // HStack for horizontal alignment of share and post buttons
                            HStack {
                                // Share button (placeholder action)
                                Button(action: {
                                    // Share Action
                                }, label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 20)
                                })
                                
                                Spacer()
                                
                                // Post button triggers message posting action
                                Button(action: {
                                    postMessage(user_id: userId, text: noteMessage, visibility: "friends", locationDataManager: locationDataManager) {
                                        result in
                                        switch result {
                                        case .success(let response):
                                            print("Message posted successfully: \(response)")
                                            
                                            
                                            do {
                                                let newMessage = try Message(
                                                    id: response._id,
                                                    user_id: userId,
                                                    location: response.location.toCLLocation(),
                                                    messageStr: response.text,
                                                    visibility: "Public")
                                                // Use newMessage here
                                                //                                                    self.storedMessages.append(newMessage)
                                                
                                                // Update messageState with the new message
                                                messageState.currentMessage = newMessage
                                                
                                            } catch {
                                                // Handle the error
                                                print("Error: \(error)")
                                            }
                                            
                                            
                                        case .failure(let error):
                                            print("Error posting message: \(error.localizedDescription)")
                                        }
                                        isPresented.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 20)
                                })
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                        }
                    }
                    .frame(width: geometry.size.width - 40, height: geometry.size.width - 40)
                    
                    Spacer()
                }
            }
        }
    }
}
