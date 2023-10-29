//
//  Home.swift
//  here
//
//  Created by Lindsay Chen on 10/14/23.
//

import SwiftUI
import ARKit
import RealityKit

struct HomePageView: View {
    @State private var isShowingProfile = false
    @State private var isShowingMessages = false
    @State private var isShowingPosts = false
    
    var body: some View {
        CustomARViewRepresentable()
            .ignoresSafeArea()
            .overlay(alignment: .bottom){
                ScrollView(.horizontal){
                    VStack(){
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
                        PostsPopup(isPresented: $isShowingPosts)
                    }
                
            }
        }
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


