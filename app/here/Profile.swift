//
//  Profile.swift
//  here
//
//  Created by Lindsay Chen on 10/13/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ProfileHeader()

                    Divider()

                    ProfileStats()

                    Divider()

                    PostGrid()
                }
            }
            .navigationBarTitle("Profile", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ProfileHeader: View {
    var body: some View {
        HStack {
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.title)
                    .bold()
                
                Text("Bio or description")
                    .font(.subheadline)

                ProfileButtons()
            }

            Spacer()
        }
        .padding()
    }
}

struct ProfileButtons: View {
    var body: some View {
        HStack {
            Button(action: {
                // Action for Edit Profile
            }) {
                Text("Edit Profile")
                    .font(.headline)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
            }

            Button(action: {
                // Action for Share Profile
            }) {
                Text("Share Profile")
                    .font(.headline)
                    .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    .border(Color.gray, width: 1)
                    .cornerRadius(5)
            }

            Button(action: {
                // Action for Add Friend
            }) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 20))
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
        }
    }
}

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
                        .foregroundColor(.gray)

                    Text(stat.value)
                        .font(.headline)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 3)
            }
        }
        .padding()
    }
}

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
                .foregroundColor(.gray)
        }
    }
}

struct PostGrid: View {
    var body: some View {
        // Replace with a grid or list of posts
        Text("Posts Grid")
            .font(.title)
            .padding()
    }
}

#Preview {
    ContentView()
}
