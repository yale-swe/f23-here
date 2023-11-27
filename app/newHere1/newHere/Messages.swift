import SwiftUI

/**
 * MessagesPopup
 *
 * A SwiftUI view for displaying a popup containing message buttons. It uses a binding variable to control its visibility.
 *
 * Features:
 * - Background image for aesthetic enhancement.
 * - A close button to dismiss the popup.
 * - A list of message buttons created in a loop, each with a profile picture and title.
 */
struct MessagesPopup: View {
    @Binding var isPresented: Bool // Binding to control the visibility of the popup
        
    var body: some View {
        ZStack{
            // Background image for the popup
            Image("cross_campus")
                .font(.system(size: 50))
            LazyVStack {
                HStack {
                    Spacer()
                    // Close button for the popup
                    Button(action: {
                        isPresented.toggle() // Close the popup
                    }) {
                        Text("Close")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                }
                // Loop to create message buttons
                ForEach(1...5, id: \.self) { count in
                    Button(action: {}) {
                        HStack {
                            ProfilePicture()
                            Text("Message Title")
                                .foregroundColor(.black)
                            Image(systemName: "map")
                                .foregroundColor(.black)
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Set margins for the entire button
                    }
                    .background(Color.white.opacity(0.9))
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    
                }
            }
            
        }
    }
}

/**
 * ProfilePicture
 *
 * A subview within MessagesPopup for displaying a profile picture. 
 * It presents an image in a circular shape, used alongside message titles in MessagesPopup.
 */
struct ProfilePicture: View {
    var body : some View {
        Image("profilePicture")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding()
    }
}
