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
            ScrollView{
                VStack {
                    HStack {
                        Spacer()
                        // Close button for the popup
                        Button(action: {
                            isPresented.toggle() // Close the popup
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 28))
                                .foregroundColor(Color.white)
                                .shadow(radius: 2.0)
                        }
                        .padding(.trailing, 20)
                    }
                    // Loop to create message buttons
                    ForEach(1...5, id: \.self) { count in
                        Button(action: {}) {
                            HStack {
                                ProfilePicture()
                                Text("Message Title")
                                    .foregroundColor(.white)
                                    .shadow(radius: 2.0)
                                Image(systemName: "map")
                                    .foregroundColor(.white)
                                    .shadow(radius: 2.0)
                            }
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Set margins for the entire button
                        }
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
            .frame(width: 350, height: 500)
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
}
/**
 * ProfilePicture .frame(width: 350, height: 500)
 .background(Color.white.opacity(0.5))
 .cornerRadius(12)
 .shadow(radius: 10)
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
