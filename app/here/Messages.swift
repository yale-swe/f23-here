//
//  Messages.swift
//  here
//
//  Created by Eric  Wang on 10/14/23.
//

import SwiftUI

struct MessagesPopup: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack{
            Image("cross_campus")
                .font(.system(size: 50))
            LazyVStack {
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
                ForEach(1...5, id: \.self) { count in
                    Button(action: {}) {
                        HStack {
                            ProfilePicture()
                            Text("Message Title")
                                .foregroundColor(.black)
                            Image(systemName: "map")
                                .foregroundColor(.black)
                        }
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)) // Set margins for the entire button
                    }
                    .background(Color.white.opacity(0.9))
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    
                }
            }
            
        }
    }
}

struct ProfilePicture: View {
    var body : some View {
        Image("profilePicture")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .padding()
    }
}

