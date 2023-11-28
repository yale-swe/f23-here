import SwiftUI

/**
 * ProfilePopup
 *
 * A SwiftUI view for displaying a user's profile in a popup format. It includes a header, profile statistics, and options to interact with the profile, such as viewing friends and posts.
 *
 * Properties:
 * - isPresented: Binding to control the visibility of the popup.
 * - isShowingFriends: State to manage the display of friends list.
 *
 * Subviews:
 * - ProfileHeader: Displays the user's profile picture and basic information.
 * - ProfileStats: Shows key statistics like the number of notes and friends.
 * - PostGrid: A placeholder for displaying the user's posts in a grid layout.
 */
struct ProfilePopup: View {
    @Binding var isPresented: Bool // Added binding to control visibility
    @State private var isShowingFriends: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack {
                    // Header with close button
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresented.toggle() // Close the popup
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 28))
                                .foregroundColor(Color.white)
                                .shadow(radius: 2.0)
                        }
                        .padding(.trailing, 20) // Adjust the position of the close button
                    }
                    ProfileHeader() // User profile header
                    Divider()
                    ProfileStats() // User profile statistics
                    Divider()
                    Button(action: {
                        isShowingFriends.toggle()
                    }) {
                        Text("Show Friends")
                            .font(.headline)
                            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                            .border(Color.gray, width: 1)
                            .foregroundColor(Color.gray)
                            .cornerRadius(5)
                    }
                    PostGrid() // Grid to show posts
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .sheet(isPresented: $isShowingFriends) {
                    // Friends.swift => Friends struct
                    Friends(isPresented: $isShowingFriends) // Pass the binding to control visibility
                }
            }
        }
            .frame(width: 350, height: 600)
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(radius: 10)
       // Adjust size and alignment
    }
}

/**
 * ProfileHeader
 *
 * A subview within ProfilePopup that displays the user's profile picture, name, and a short bio.
 */
struct ProfileHeader: View {
    var body: some View {
        HStack {
            // Profile picture
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding()
            // User name and bio
            VStack(alignment: .leading, spacing: 8) {
                
                Text(userName)
                    .font(.title)
                    .bold()
                
                Text("Bio or description")
                    .font(.subheadline)
                
            }

            Spacer()
        }
        .padding()
    }
}

/**
 * ProfileButtons
 *
 * A subview within ProfilePopup that provides action buttons for editing the user's profile and adding friends.
 */
struct ProfileButtons: View {
    var body: some View {
        HStack {
            // Edit profile button
            Button(action: {
                // Action for Edit Profile
            }) {
                Text("Edit")
                    .font(.headline)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
            }

            // Add friend button
            Button(action: {
                // Action for Add Friend
            }) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 20))
                    .padding(10)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white.opacity(0.8))
                    .clipShape(Circle())
            }
        }
    }
}

/**
 * ProfileStats
 *
 * A subview within ProfilePopup for displaying key statistics about the user's profile, such as the number of notes and friends.
 */
struct ProfileStats: View {
    let stats: [(title: String, value: String)] = [
        ("Notes", "10"),
        ("Friends", "100")
    ]

    var body: some View {
        HStack {
            ForEach(stats, id: \.title) { stat in
                VStack {
                    Text(stat.title)
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.8))

                    Text(stat.value)
                        .font(.headline)
                }
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .shadow(radius: 3)
            }
        }
        .padding()
    }
}

/**
 * ProfileStatItem
 *
 * A component within ProfileStats that represents a single statistic item, displaying a title and a value.
 */
struct ProfileStatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
                .bold()

            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.8))
        }
    }
}

/**
 * PostGrid
 *
 * A subview within ProfilePopup intended to display the user's posts in a grid format. Currently serves as a placeholder.
 */
struct PostGrid: View {
    var body: some View {
        // Placeholder for posts grid
        Text("Posts Grid")
            .font(.title)
            .padding()
    }
}
