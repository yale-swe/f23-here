//
//  Message_View.swift
//  here
//
//  Created by Liyang Wang on 10/10/23.
//

import SwiftUI
import CoreLocation

struct PostsPopup: View {
    @Binding var isPresented: Bool
    @Binding var storedMessages: [Message]
    
    @State private var noteMessage: String = "This is your message!"
    
    @State private var storedMessage: Message?
    
    
    let senderName: String = "Username"

    @EnvironmentObject var locationDataManager: LocationDataManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {

                VStack(spacing: 10) {
                    Spacer()

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
                    .padding(.leading, 20)

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)

                        VStack {
                            TextEditor(text: $noteMessage)
                                .padding(.all, 30)

                            Spacer(minLength: 20)

                            HStack {
                                Button(action: {
                                    // Share Action
                                }, label: {
                                    Image(systemName: "square.and.arrow.up.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .padding(.leading, 20)
                                })

                                Spacer()

                                Button(action: {
                                    if let currentLocation = locationDataManager.location {
                                        let newMessage = Message(location: currentLocation,
                                                             author: senderName,
                                                             messageStr: noteMessage)
                                        self.storedMessages.append(newMessage)
                                    }
                                    
                                }, label: {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .frame(width: 24, height: 24)
                                        .padding(.trailing, 20)
                                })
                            }
                            .padding(.bottom, 25)
                        }
                    }
                    .opacity(0.5)
                    .frame(width: geometry.size.width - 40, height: geometry.size.width - 40)
                    
                    Spacer()
                }
            }
        }
    }
}
