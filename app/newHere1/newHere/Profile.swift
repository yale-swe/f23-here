//
//  Profile.swift
//  here
//
//  Created by Lindsay Chen on 10/13/23.
//
//  Description:
//  This file defines the ProfilePopup view along with its subviews such as ProfileHeader, ProfileButtons,
//  ProfileStats, and PostGrid for the 'here' application. It includes functionality for displaying user profiles
//  with options to view and edit profile details.

import SwiftUI

struct ProfilePopup: View {
    @Binding var isPresented: Bool // Added binding to control visibility
    @State private var isShowingFriends: Bool = false
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                // Header with close button
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
                        .cornerRadius(5)
                }
                PostGrid() // Grid to show posts
            }
            .sheet(isPresented: $isShowingFriends) {
                // Friends.swift => Friends struct
                Friends(isPresented: $isShowingFriends) // Pass the binding to control visibility
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top) // Adjust size and alignment
    }
}

/// View for displaying the user's profile header.
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

/// View for displaying profile action buttons.
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

/// View for displaying profile statistics.
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

/// View for displaying individual profile stat item.
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

/// View for displaying the posts grid.
struct PostGrid: View {
    var body: some View {
        // Placeholder for posts grid
        Text("Posts Grid")
            .font(.title)
            .padding()
    }
}
