import SwiftUI
import ARKit
import UIKit

/**
 * MessageState
 *
 * A class that manages the state of the current message in the application.
 * It is an observable object that can be used in SwiftUI views to react to changes in the current message state.
 */
class MessageState: ObservableObject {
    @Published var currentMessage: Message?
}

/**
 * FetchedMessagesState
 *
 * A class that manages the state of messages fetched from a data source in the application.
 * It is an observable object that tracks an array of 'Message' objects.
 */
class FetchedMessagesState: ObservableObject {
    var fetchedMessages: [Message]?
    
}

class FetchedFriendsState: ObservableObject {
    var fetchedFriends: [String: String]?
}

    
func convertGeoJSONPointToCLLocation(_ geoJSONPoint: GeoJSONPoint) -> CLLocation {
    // Your conversion logic here
    // Example: Assuming GeoJSONPoint has latitude and longitude properties
    return CLLocation(latitude: geoJSONPoint.coordinates[0], longitude: geoJSONPoint.coordinates[1])
}
    
func fetchUserFriends(userId: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
    // Call the API or use your existing logic to fetch friends
    // Update friendList when the data is available
    getAllUserFriends(userId: userId) { result in
        switch result {
        case .success(let friends):
            completion(.success(friends))

        case .failure(let error):
            completion(.failure(error))
        }
    }
}


//func fetchUserMessages(userId: String, completion: @escaping (Result<[Message], Error>) -> Void) {
//    // Use your existing API call logic
//    getUserMessages(userId: userId) { result in
//        switch result {
//        case .success(let messageResponses):
//            // Map MessageResponse objects to Message objects
//            let messages = messageResponses.map { response in
//                Message(
//                    id: response._id,
//                    user_id: response.user_id,
//                    // location is stored as GeoJSONPoint in response (convert to CLLocation)
//                    location: convertGeoJSONPointToCLLocation(response.location),
//                    messageStr: response.text,
//                    visibility: response.visibility
//                )
//            }
//            completion(.success(messages))
//
//        case .failure(let error):
//            completion(.failure(error))
//        }
//    }
//}

/**
 * HomePageView
 *
 * The main view for the home page of the AR application. This view integrates an AR experience using CustomARViewRepresentable
 * and provides a user interface for navigating to different features such as profiles, messages, and posts.
 * It manages various UI states using @State and @StateObject properties and provides sheets for displaying popups.
 *
 * The view overlays control buttons over the AR view and presents modals for profiles, messages, and posts based on user interaction.
 * It utilizes @EnvironmentObject to inject and use LocationDataManager within the view hierarchy.
 */
struct HomePageView: View {
    @State private var isShowingProfile = false
    @State private var isShowingMessages = false
    @State private var isShowingPosts = false
    @StateObject var messageState = MessageState()
    @StateObject var fetchedFriendsState = FetchedFriendsState()
    @StateObject var fetchedMessagesState = FetchedMessagesState()
    @State private var shareSheetPresented = false
    @State private var screenshot: UIImage?
    @State private var showCaptureAlert = false
    
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    /// The body of the view, presenting the AR view along with overlay controls for navigation and interaction.
    var body: some View {
        ZStack{
        CustomARViewRepresentable()
            .edgesIgnoringSafeArea(.all)
            .environmentObject(messageState)
            .environmentObject(fetchedMessagesState)
            .environmentObject(locationDataManager)
            .overlay(alignment: .bottom){
                // Overlay containing buttons for various features like map, messages, posts, etc.
                // Each button toggles the state to show respective views or popups.
                Spacer()
                HStack{
                    HStack(alignment: .bottom, spacing: 28.0) {
                        Button{
                            
                        }label:
                        {
                            Image(systemName: "map")
                                .foregroundColor(.white)
                        }
                        
                        Button{isShowingMessages.toggle()
                            
                        }label:
                        {
                            Image(systemName: "message")
                                .foregroundColor(.white)
                        }
                        
                        Button{isShowingPosts.toggle()
                            
                        }label:
                        {
                            Image(systemName: "plus.circle")
                                .scaleEffect(2)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            updateMetrics { result in
                                switch result {
                                case .success(_):
                                    print("Metrics incremented successfully")
                                case .failure(let error):
                                    print("Error incrementing metrics: \(error.localizedDescription)")
//                                    self.errorMessage = error.localizedDescription
                                }
                            }

                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                                screenshot = captureScreenshot(of: window)
                                showCaptureAlert = true
                            }
                        }) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $shareSheetPresented, onDismiss: {
                            screenshot = nil
                        }) {
                            if let screenshot = screenshot {
                                ShareSheet(items: [screenshot])
                            }
                        }
                        .alert(isPresented: $showCaptureAlert) {
                            Alert(
                                title: Text("Screen captured!"),
                                message: Text("Wanna share it?"),
                                primaryButton: .default(Text("Share")) {
                                    shareSheetPresented = true
                                },
                                secondaryButton: .cancel()
                            )
                        }

                        
                        Button{isShowingProfile.toggle()
                            
                        }label:
                        {
                            Image(systemName: "person")
                                .foregroundColor(.white)
                        }
                        
                    }.alignmentGuide(.bottom) { d in d[.bottom]}
                        .font(.largeTitle)
                        .padding(10)
                }
            }
        // Render popups upon state variables being true.
        
        if isShowingPosts {
            PostsPopup(isPresented: $isShowingPosts, messageState: messageState, locationDataManager: locationDataManager)
                .frame(width: 300, height: 300)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding()
        }
        if isShowingProfile {
            ProfilePopup(isPresented: $isShowingProfile)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding()
        }
        
            if isShowingMessages {
                let defaultLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
                MessagesPopup(isPresented: $isShowingMessages, fetchedMessages: fetchedMessagesState.fetchedMessages ?? [])
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                    .environmentObject(fetchedMessagesState)
                    .onAppear {
                        if let friendList = fetchedFriendsState.fetchedFriends?.values.sorted() {
                            getFilteredMessages(userId: userId, location:LocationDataManager().location ?? defaultLocation, friendList: friendList) {
                                result in
                                switch result {
                                case .success(let messages):
                                    fetchedMessagesState.fetchedMessages = messages
                                case .failure(let error):
                                    print("Error fetching messages: \(error)")

                                }
                            }
                        } else {
                            getAllUserFriends(userId: userId) { result in
                                switch result {
                                case .success(let friends):
                                    getFilteredMessages(userId: userId, location: LocationDataManager().location ?? defaultLocation, friendList: friends.values.sorted()) { result in
                                        switch result {
                                        case .success(let messages):
                                            fetchedMessagesState.fetchedMessages = messages
                                        case .failure(let error):
                                            print("Error fetching messages: \(error)")
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print("Error fetching friend list: \(error)")
                                }
                            }
                        }
                    }
            
//            if isShowingMessages {
//                let defaultLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
                
                 //Rest of your original code..
//            MessagesPopup(isPresented: $isShowingMessages, fetchedMessagesㄴ: fetchedMessagesState.fetchedMessages ?? [])
//                .background(Color.white.opacity(0.5))
//                .cornerRadius(12)
//                .shadow(radius: 10)
//                .padding()
//                .environmentObject(fetchedMessagesState)
//                .onAppear {
//                    getFilteredMessages(userId: userId, location: LocationDataManager().location ?? defaultLocation, friendList: fetchUserFriends(userId: userId, completion: (Result<[String : String], Error>) -> Void)) { result in
//                        switch result {
//                        case .success(let messages):
//                            fetchedMessagesState.fetchedMessages = messages
//
//                        case .failure (let error):
//                            print("Error")
//                        }
//                    }
//                }
//                .onAppear {
//                    if let friendList = fetchedFriendsState.fetchedFriends {
//                        // Friend list is available
//                        getFilteredMessages(userId: userId, location: LocationDataManager().location ?? defaultLocation, friendList: friendList) { result in
//                            switch result {
//                            case .success(let messages):
//                                fetchedMessagesState.fetchedMessages = messages
//
//                            case .failure(let error):
//                                print("Error fetching messages: \(error)")
//                            }
//                        }
//                    } else {
//                        // Fetch friend list first
//                        fetchUserFriends(userId: userId) { result in
//                            switch result {
//                            case .success(let friends):
//                                // Now the friend list is available, fetch messages
//                                getFilteredMessages(userId: userId, location: LocationDataManager().location ?? defaultLocation, friendList: friends) { result in
//                                    switch result {
//                                    case .success(let messages):
//                                        fetchedMessagesState.fetchedMessages = messages
//
//                                    case .failure(let error):
//                                        print("Error fetching messages: \(error)")
//                                    }
//                                }
//
//                            case .failure(let error):
//                                print("Error fetching friend list: \(error)")
//                            }
//                        }
//                    }
//                }

        }
    }
    

        }
    }


    
/**
 * HomePageView_Previews
 *
 * A preview provider for HomePageView, facilitating the rendering of the HomePageView in Xcode's canvas.
 */
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


