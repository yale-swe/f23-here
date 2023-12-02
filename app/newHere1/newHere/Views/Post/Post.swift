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

    @ObservedObject var viewModel: PostViewModel
    

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
                            .frame(width: geometry.size.width - 40 > 0 ? geometry.size.width - 40 : 300, height: geometry.size.width - 40 > 0 ? geometry.size.width - 40 : 300)
                            .shadow(radius: 5)
                        
                        // VStack for arranging TextEditor and buttons vertically
                        VStack {
                            ZStack(alignment: .leading) {
                                if viewModel.noteMessage.isEmpty && viewModel.isEditing == false {
                                    Text("Leave a message here")
                                        .foregroundColor(.gray)
                                        .padding(.all, 30)
                                }
                                TextEditor(text: $viewModel.noteMessage)
                                    .accessibilityIdentifier("MessageEditor")
                                    .onTapGesture {
                                        viewModel.isEditing = true
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
                                .accessibilityIdentifier("Share Post")

                                Spacer()
                                
                                // Post button triggers message posting action
                                Button(action: {
                                    
                                    submitPost()
                                    
                                }, label: {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 20)
                                })
                                .accessibilityIdentifier("Submit Post")
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 25)
                        }
                    }
                    .frame(width: geometry.size.width - 40 > 0 ? geometry.size.width - 40 : 300, height: geometry.size.width - 40 > 0 ? geometry.size.width - 40 : 300)

                    Spacer()
                }
            }
        }
    }
    
    private func submitPost() {
        
        guard !userId.isEmpty else {
            debugPrint("userId should be empty")
            return
        }
        
        guard !viewModel.noteMessage.isEmpty else {
            debugPrint("noteMessage should be empty")
            return
        }
        
        viewModel.postMessage()
    }
}
