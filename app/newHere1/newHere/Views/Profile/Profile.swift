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
 */
struct ProfilePopup: View {
    @Binding var isPresented: Bool // Added binding to control visibility
    @StateObject var viewModel = UserProfileViewModel()
    @State private var isShowingFriends: Bool = false
    @State private var isShowingEditProfile: Bool = false
    
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
                    ProfileHeader(viewModel: viewModel) // User profile header
                    Divider()
                    
                    HStack {
                        VStack {
                            Text("Edit Profile")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.8))
                            
                            Image (systemName: "pencil")
                                .foregroundColor(Color.white)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .onTapGesture {
                            isShowingEditProfile.toggle() // Toggle the state to show friends
                        }
                        
                        VStack {
                            
                            Text("Friends")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.8))
                            
                            Image(systemName: "person.2.fill")
                                .foregroundColor(Color.white)

                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .onTapGesture {
                            isShowingFriends.toggle() // Toggle the state to show friends
                        }
                    }
                    .padding()
                    
                    Divider()
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
//                .sheet(isPresented: $isShowingFriends) {
//                    // Friends.swift => Friends struct
//                    Friends(isPresented: $isShowingFriends) // Pass the binding to control visibility
//                }
            }
            
            if isShowingFriends {
                Friends(isPresented: $isShowingFriends)
                    .background(Color.gray)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
            }
            
            if isShowingEditProfile {
                EditProfile(isPresented: $isShowingEditProfile, viewModel: viewModel)
                    .background(Color.gray)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
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
    @ObservedObject var viewModel: UserProfileViewModel
    var body: some View {
        HStack {
            // Profile picture
            if let uiImage = viewModel.profileImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .padding()
                        } else {
                            Image(systemName: "person.crop.circle.fill") // Fallback image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .padding()
                        }
            // User name and bio
            VStack(alignment: .leading, spacing: 8) {
                
                Text(viewModel.username)
                    .font(.title)
                    .bold()
                
                Text(viewModel.email)
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
            VStack {
                Text("Notes")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.8))

                Text("10")
                    .font(.headline)
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 3)
            
            VStack {
                Text("Friends")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.8))

                Text("100")
                    .font(.headline)
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 3)
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

