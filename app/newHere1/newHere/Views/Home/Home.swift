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
    @Published var fetchedMessages: [Message]?
}

class FriendIdListState: ObservableObject {
    @Published var friendIdList: [String] = []
}

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
    enum SwipeSelection {
        case friends, explore
    }

    @State private var currentSelection: SwipeSelection = .friends
    @State private var offset: CGFloat = 0
    @State private var isShowingProfile = false
    @State private var isShowingMessages = false
    @State private var isShowingPosts = false
    @State private var shareSheetPresented = false
    @State private var screenshot: UIImage?
    @State private var showCaptureAlert = false
    
    @StateObject var fetchedMessagesState = FetchedMessagesState()
    @StateObject var messageState = MessageState()
    @StateObject var updateARState = UpdateARState()
    @StateObject var friendIDListState = FriendIdListState()
    
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    func swipeableView() -> some View {
        HStack(spacing: 12) {
            Text("Friends")
                .fontWeight(currentSelection == .friends ? .bold : .regular)
                .opacity(currentSelection == .friends ? 1 : 0.7)
                .scaleEffect(currentSelection == .friends ? 1 : 0.8)
                .offset(x: currentSelection == .friends ? offset : 0)

            Text("Explore")
                .fontWeight(currentSelection == .explore ? .bold : .regular)
                .opacity(currentSelection == .explore ? 1 : 0.7)
                .scaleEffect(currentSelection == .explore ? 1 : 0.8)
                .offset(x: currentSelection == .explore ? offset : 0)
        }
        .foregroundColor(.white)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation.width
                }
                .onEnded { _ in
                    if self.offset > 50 {
                        self.currentSelection = .friends
                    } else if self.offset < -50 {
                        self.currentSelection = .explore
                    }
                    self.offset = 0
                }
        )
    }

    
    /// The body of the view, presenting the AR view along with overlay controls for navigation and interaction.
    var body: some View {
        ZStack{
        CustomARViewRepresentable()
            .edgesIgnoringSafeArea(.all)
            .environmentObject(messageState)
            .environmentObject(fetchedMessagesState)
            .environmentObject(locationDataManager)
            .environmentObject(updateARState)
            .environmentObject(friendIDListState)
            .overlay(alignment: .bottom){
                // Overlay containing buttons for various features like map, messages, posts, etc.
                // Each button toggles the state to show respective views or popups.
                Spacer()
                VStack{
//                    swipeableView()
                    HStack{
                        HStack(alignment: .bottom, spacing: 28.0) {
                            Button(action: {updateARState.updateTrue = true})
                            {
                                Image(systemName: "arrow.clockwise")
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
            MessagesPopup(isPresented: $isShowingMessages)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .shadow(radius: 10)
                .padding()
        }
    }
            // Render popups upon state variables being true.
//            .sheet(isPresented: $isShowingProfile) {
//                ProfilePopup(isPresented: $isShowingProfile) // Pass the binding to control visibility
//            }
//            .sheet(isPresented: $isShowingMessages) {
//                MessagesPopup(isPresented: $isShowingMessages)
//            }
//            .sheet(isPresented: $isShowingPosts){
//                PostsPopup(isPresented: $isShowingPosts)
//                    .environmentObject(messageState)
//            }

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


