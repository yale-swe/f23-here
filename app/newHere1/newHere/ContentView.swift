//
//  ContentView.swift
//  newHere
//
//  Created by Eric  Wang on 10/28/23.
//
//  Description:
//  This file defines the ContentView struct, which serves as the main view for the application.
//  It handles user authentication and navigation between the HomePage and Login views.

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var isRegistered = false
    @ObservedObject var locationDataManager = LocationDataManager()
    
    @State private var userId: String = ""
    
    /// The body of the view, which conditionally presents either the HomePageView or LoginView based on authentication status.
    var body: some View {
        if isAuthenticated {
                HomePageView()
                    .environmentObject(locationDataManager)
        } else {
            LoginView(isAuthenticated: $isAuthenticated)
        }
    }
}

/// A preview provider for ContentView, used for rendering the view in Xcode's canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

