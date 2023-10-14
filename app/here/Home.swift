//
//  Home.swift
//  here
//
//  Created by Lindsay Chen on 10/14/23.
//

import SwiftUI

struct HomePageView: View {
    @State private var isShowingProfile = false
    var body: some View {
        VStack(){
            Spacer()
            HStack{
                HStack(alignment: .bottom, spacing: 28.0) {
                    Button{
                        
                    }label:
                    {
                        Image(systemName: "map")
                    }
                    
                    Button{
                        
                    }label:
                    {
                        Image(systemName: "message")
                    }
                    
                    Button{
                        
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
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}


