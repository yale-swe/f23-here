import SwiftUI

struct Friends: View {
    @Binding var isPresented: Bool
    
    // State to hold the friends list
    @State private var friendsList: [String] = []
    @State private var errorMessage: String?
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            
            // top bar
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
            
            // search bar
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
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
            } else {
                List(friendsList, id: \.self) { friend in
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
//                            
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
            getAllUserFriends(userId: userId) { result in
                switch result {
                case .success(let response):
                    print("Friends fetched successfully: \(response)")                    
                    self.friendsList = response // Assuming response is [String]
                    
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
