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
    
    @State private var noteMessage: String = "This is your message!"
    
    @EnvironmentObject var messageState: MessageState
    
    let senderName: String = "Username"
    
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    

    var body: some View {
        // GeometryReader for dynamic layout based on screen size
        GeometryReader { geometry in
            // ZStack for layering views
            ZStack {
                // VStack for vertical arrangement of UI elements
                VStack(spacing: 10) {
                    Spacer()
                    
                    // HStack for horizontal alignment of close button
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented.toggle() // Close the popup
                        }) {
                            Text("Close")
                                .font(.headline)
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white.opacity(0.8))
                                .cornerRadius(10)
                        }
                        .padding(.trailing, 20) // Adjust the position of the close button
                    }
                    .padding(.leading, 20)
                    
                    // ZStack for styling the message input area
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                        
                        // VStack for arranging TextEditor and buttons vertically
                        VStack {
                            TextEditor(text: $noteMessage)
                                .padding(.all, 30)
                            
                            Spacer(minLength: 20)
                            
                            // HStack for horizontal alignment of share and post buttons
                            HStack {
                                // Share button (placeholder action)
                                Button(action: {
                                    // Share Action
                                }, label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .resizable()
                                        .foregroundColor(.blue.opacity(0.8))
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
                                                    messageStr: response.text)
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
                                    }
                                }, label: {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .foregroundColor(.blue.opacity(0.8))
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 20)
                                })
                            }
                            .padding(.bottom, 25)
                        }
                    }
                    .opacity(0.5)
                    .frame(width: geometry.size.width - 40, height: geometry.size.width - 40)
                    
                    Spacer()
                }
            }
        }
    }
}
