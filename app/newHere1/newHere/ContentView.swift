//
//  ContentView.swift
//  newHere
//
//  Created by Eric  Wang on 10/28/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isRegistered = false

    var body: some View {
        if isRegistered {
            HomePageView()
        } else {
            RegistrationView(isRegistered: $isRegistered)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
