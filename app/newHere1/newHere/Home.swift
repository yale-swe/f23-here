//
//  Home.swift
//  here
//
//  Created by Lindsay Chen on 10/14/23.
//

import SwiftUI
import ARKit

class MessageState: ObservableObject {
    @Published var currentMessage: Message?
}

struct HomePageView: View {
    @State private var isShowingProfile = false
    @State private var isShowingMessages = false
    @State private var isShowingPosts = false
    @State private var storedMessages: [Message] = []
    
    
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    @StateObject var messageState = MessageState()
    
    var body: some View {
        CustomARViewRepresentable()
            .environmentObject(messageState)
            .ignoresSafeArea()
            .overlay(alignment: .bottom){
                    VStack(){
                        if let currentLocation = locationDataManager.location {
                          Text("Your current location is:")
                          Text("Latitude: \(currentLocation.coordinate.latitude.description)")
                          Text("Longitude: \(currentLocation.coordinate.longitude.description)\n")
                          } else {
                              Text("Finding your location...\n")
                              ProgressView()
                          }

                              // render the stored messages on the screen
                              if !storedMessages.isEmpty {
                                  List {
                                      ForEach(0..<storedMessages.count, id:\.self) { i in
                                          Text(storedMessages[i].displayMessage())
                                      }
                                  }
                                  .listStyle(PlainListStyle())
                                  .background(Color.clear) // Set the list background to clear
                              }
                              else {
                                  Text("No Messages Stored!")
                          }
                          
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
                    .sheet(isPresented: $isShowingProfile) {
                        ProfilePopup(isPresented: $isShowingProfile) // Pass the binding to control visibility
                    }
                    .sheet(isPresented: $isShowingMessages) {
                        MessagesPopup(isPresented: $isShowingMessages)
                    }
                    .sheet(isPresented: $isShowingPosts){
                        PostsPopup(isPresented: $isShowingPosts, storedMessages: $storedMessages)
                            .environmentObject(messageState)
                    }
                
            }
        }
        
    
}

//struct HomePageView: View {
//    @State private var isShowingProfile = false
//    @State private var isShowingMessages = false
//    @State private var isShowingPosts = false
//    
//    @State private var storedMessages: [Message] = []
//    
//    @EnvironmentObject var locationDataManager: LocationDataManager
//    
//    var body: some View {
//        CustomARViewRepresentable()
//            .ignoreSafeArea()
//            .overlay(alignment: .bottom){}
//        
////        VStack(){
////            
////            // display current locaation
////            if let currentLocation = locationDataManager.location {
////                Text("Your current location is:")
////                Text("Latitude: \(currentLocation.coordinate.latitude.description)")
////                Text("Longitude: \(currentLocation.coordinate.longitude.description)\n")
////            } else {
////                Text("Finding your location...\n")
////                ProgressView()
////            }
////            
////            // render the stored messages on the screen
////            if !storedMessages.isEmpty {
////                List {
////                    ForEach(0..<storedMessages.count, id:\.self) { i in
////                        Text(storedMessages[i].displayMessage())
////                    }
////                }
////            }
////            else {
////                Text("No Messages Stored!")
////            }
////            
////            Spacer()
////            HStack{
////                HStack(alignment: .bottom, spacing: 28.0) {
////                    Button{
////                        
////                    }label:
////                    {
////                        Image(systemName: "map")
////                    }
////                    
////                    Button{isShowingMessages.toggle()
////                        
////                    }label:
////                    {
////                        Image(systemName: "message")
////                    }
////                    
////                    Button{isShowingPosts.toggle()
////                        
////                    }label:
////                    {
////                        Image(systemName: "plus.circle")
////                            .scaleEffect(2)
////                    }
////                    
////                    Button{
////                        
////                    }label:
////                    {
////                        Image(systemName: "square.and.arrow.up")
////                    }
////                    
////                    Button{isShowingProfile.toggle()
////                        
////                    }label:
////                    {
////                        Image(systemName: "person")
////                    }
////        
////                }.alignmentGuide(.bottom) { d in d[.bottom]}
////                    .font(.largeTitle)
////                    .padding(10)
////            }
////         }
////        .sheet(isPresented: $isShowingProfile) {
////            ProfilePopup(isPresented: $isShowingProfile) // Pass the binding to control visibility
////        }
////        .sheet(isPresented: $isShowingMessages) {
////            MessagesPopup(isPresented: $isShowingMessages)
////        }
////        .sheet(isPresented: $isShowingPosts){
////            PostsPopup(isPresented: $isShowingPosts, 
////                       storedMessages: $storedMessages)
////                .environmentObject(locationDataManager)
////        }
////    }
//}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


