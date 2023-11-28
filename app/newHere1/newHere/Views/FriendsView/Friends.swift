
import SwiftUI

/**
 * Friends View
 *
 * A SwiftUI view for managing a user's friends list. It allows users to search, add, and delete friends.
 * The view is presented modally and includes a dynamic list of friends with individual delete options.
 * It utilizes @Binding to control the presentation state, and @State for managing the friends list, error messages, and search text.
 *
 * Features:
 * - Top bar with a close button to dismiss the view.
 * - Search bar for filtering friends or adding new ones.
 * - Dynamic list of friends with an option to delete individual friends.
 * - Error handling with user feedback.
 *
 * Lifecycle:
 * - The friends list is fetched and updated when the view appears.
 *
 * External Dependencies:
 * - The view expects functions for adding and deleting friends, and for fetching the full friends list.
 * - Ensure functions like `getAllUserFriends`, `addFriendByName`, and `deleteFriendByName` are defined with appropriate signatures.
 */
struct Friends: View {
    @Binding var isPresented: Bool
    
    // State to hold the friends list
    @State private var friendsList: [String] = []
    @State private var errorMessage: String?
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            
            // top bar with close button
            HStack {
                Spacer()
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
                .padding(.trailing, 20) // Adjust the position of the close button
            }
            
            // search bar and add friend button
            HStack {
                       TextField("Search...", text: $searchText)
                           .padding(7)
                           .padding(.horizontal, 25)
                           .background(Color(.systemGray6))
                           .cornerRadius(8)
                           .overlay(
                               HStack {
                                   Image(systemName: "magnifyingglass")
                                       .foregroundColor(.gray)
                                       .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                       .padding(.leading, 8)
                                   
                                   if !searchText.isEmpty {
                                       Button(action: {
                                           searchText = ""
                                       }) {
                                           Image(systemName: "multiply.circle.fill")
                                               .foregroundColor(.gray)
                                               .padding(.trailing, 8)
                                       }
                                   }
                               }
                           )
                           .autocapitalization(.none)
                           .keyboardType(.webSearch)

                       Button(action: {
                           // Add friend when the "Add Friend" button is tapped
                           addFriendByName(userId: userId, friendName: searchText) {
                               result in
                                  switch result {
                                  case .success(let response):
                                      print("Friend added successfully: \(response)")
                                  case .failure(let error):
                                      print("Error adding friend: \(error.localizedDescription)")
                                      self.errorMessage = error.localizedDescription
                                  }
                           }
                           
                       }) {
                           Text("Add Friend")
                               .padding(.horizontal, 16)
                               .padding(.vertical, 8)
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .cornerRadius(8)
                       }
                   }
                   .padding()
            
            // Add friend when the "Add Friend" button is tapped
            if let errorMessage = errorMessage {
                Text(errorMessage)
            } else {
                // Friends List
                List(friendsList, id: \.self) { friend in
                    // Each friend in the list with delete button
                    HStack {
                        Text(friend)
                        Spacer()
                        Button(action: {
//                            addFriendByName(userId: userId, friendName: searchText) {
//                                result in
//                                   switch result {
//                                   case .success(let response):
//                                       print("Friend added successfully: \(response)")
//                                   case .failure(let error):
//                                       print("Error adding friend: \(error.localizedDescription)")
//                                       self.errorMessage = error.localizedDescription
//                                   }
//                            }
//                            // Delete friend when the minus button is tapped
                            deleteFriendByName(userId: userId, friendName:friend) {
                                result in
                                   switch result {
                                   case .success(let response):
                                       print("Friend deleted successfully: \(response)")
                                   case .failure(let error):
                                       print("Error deleting friend: \(error.localizedDescription)")
                                       self.errorMessage = error.localizedDescription
                                   }
                            }
                        }){
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            }
        }
        .onAppear {
            // Fetch Friends List on Appear
            getAllUserFriends(userId: userId) { result in
                switch result {
                case .success(let response):
                    print("Friends fetched successfully: \(response)")                    
                    self.friendsList = response.values.map { $0 }
                    
                case .failure(let error):
                    print("Error getting friends: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

// Make sure `getAllUserFriends` has a signature similar to this:
// func getAllUserFriends(userId: String, completion: @escaping (Result<[String], Error>) -> Void)
