//
//  ContentView.swift
//  newHere
//
//  Created by Eric  Wang on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var locationDataManager = LocationDataManager()
    
    
    
    var body: some View {        
        HomePageView()
            .environmentObject(locationDataManager)
    }
}

#Preview {
    ContentView()
}
