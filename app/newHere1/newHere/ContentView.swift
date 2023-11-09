//
//  ContentView.swift
//  newHere
//
//  Created by Eric  Wang on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isRegistered = false
    @ObservedObject var locationDataManager = LocationDataManager()    
    
    // testing
    @State var friendsPresented = true
    @State var userId = "653d51478ff5b3c9ace45c26"
    
    var body: some View {
        
//        Friends(isPresented: $friendsPresented, userId: $userId)
        
//        if isRegistered {
////            NavigationView {
//                HomePageView()
//                    .environmentObject(locationDataManager)
//                    
////            }
//        } else {
//            RegistrationView(isRegistered: $isRegistered)
//        }
        HomePageView()
            .environmentObject(locationDataManager)
        //        if isRegistered {
//            HomePageView()
//        } else {
//            RegistrationView(isRegistered: $isRegistered)
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

