//
//  ContentView.swift
//  newHere
//
//  Created by Eric  Wang on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var isRegistered = false
    @ObservedObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        if isAuthenticated {
//            NavigationView {
                HomePageView()
                    .environmentObject(locationDataManager)
                    
//            }
        } else {
            LoginView(isAuthenticated: $isAuthenticated)
//            RegistrationView(isRegistered: $isRegistered)
        }
//        HomePageView()
//            .environmentObject(locationDataManager)
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

