//
//  Home.swift
//  here
//
//  Created by Lindsay Chen on 10/14/23.
//
//  Description:
//  This file defines the HomePageView and associated state management classes for the application.
//  It integrates ARKit and manages UI components for messages, posts, and user profile.

import SwiftUI
import ARKit

/// Manages the state of the current message in the application.
class MessageState: ObservableObject {
    @Published var currentMessage: Message?
}

/// Manages the fetched messages state in the application.
class FetchedMessagesState: ObservableObject {
    var fetchedMessages: [Message]?
}

/// The main view for the home page of the application.
struct HomePageView: View {
    @State private var isShowingProfile = false
    @State private var isShowingMessages = false
    @State private var isShowingPosts = false
    @StateObject var messageState = MessageState()
    @StateObject var fetchedMessagesState = FetchedMessagesState()
    
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    /// The body of the view, presenting the AR view along with overlay controls for navigation and interaction.
    var body: some View {
        CustomARViewRepresentable()
            .environmentObject(messageState)
            .environmentObject(fetchedMessagesState)
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
                        }
                        
                        Button{isShowingMessages.toggle()
                            
                        }label:
                        {
                            Image(systemName: "message")
                        }
                        
                        Button{isShowingPosts.toggle()
                            
                        }label:
                        {
                            Image(systemName: "plus.circle")
                                .scaleEffect(2)
                        }
                        
                        Button{
                            
                        }label:
                        {
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button{isShowingProfile.toggle()
                            
                        }label:
                        {
                            Image(systemName: "person")
                        }
            
                    }.alignmentGuide(.bottom) { d in d[.bottom]}
                        .font(.largeTitle)
                        .padding(10)
                }
             }
            // Render popups upon state variables being true.
            .sheet(isPresented: $isShowingProfile) {
                ProfilePopup(isPresented: $isShowingProfile) // Pass the binding to control visibility
            }
            .sheet(isPresented: $isShowingMessages) {
                MessagesPopup(isPresented: $isShowingMessages)
            }
            .sheet(isPresented: $isShowingPosts){
                PostsPopup(isPresented: $isShowingPosts)
                    .environmentObject(messageState)
            }
                
        }
    }

/// A preview provider for HomePageView, used for rendering the view in Xcode's canvas.
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


