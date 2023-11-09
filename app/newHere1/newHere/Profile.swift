//
//  Profile.swift
//  here
//
//  Created by Lindsay Chen on 10/13/23.
//

import SwiftUI

//struct ContentView: View {
//    @State private var isShowingProfile = false
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack {
//                    Button(action: {
//                        isShowingProfile.toggle()
//                    }) {
//                        Text("Show Profile")
//                            .font(.headline)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//            }
//            .navigationBarTitle("Home", displayMode: .inline)
//        }
//        .sheet(isPresented: $isShowingProfile) {
//            ProfilePopup(isPresented: $isShowingProfile) // Pass the binding to control visibility
//        }
//    }
//}



struct ProfilePopup: View {
    @Binding var isPresented: Bool // Added binding to control visibility
    @State private var isShowingFriends: Bool = false
    @Binding var userId: String
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
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
                ProfileHeader()
                Divider()
                ProfileStats()
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
                PostGrid()
            }
            .sheet(isPresented: $isShowingFriends) {
                Friends(isPresented: $isShowingFriends, userId: $userId) // Pass the binding to control visibility
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top) // Adjust size and alignment
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

struct ProfileHeader: View {
    var body: some View {
        HStack {
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.title)
                    .bold()
                
                Text("Bio or description")
                    .font(.subheadline)

//                ProfileButtons()
                
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
                Text("Edit")
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
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white.opacity(0.8))
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

struct PostGrid: View {
    var body: some View {
        // Replace with a grid or list of posts
        Text("Posts Grid")
            .font(.title)
            .padding()
    }
}

//#Preview {
//    ContentView()
//}
