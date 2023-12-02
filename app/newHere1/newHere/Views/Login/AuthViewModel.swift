//
//  AuthViewModel.swift
//  newHere
//
//  Created by WD on 2023/12/1.
//

import Foundation


class AuthViewModel: ObservableObject {
    
    @Published var username: String
    @Published var password: String
    
    @Published var isRegistered: Bool = false

    @Published var isAuthenticated: Bool = false

    init(username: String = "", password: String = "", isRegistered: Bool = false, isAuthenticated: Bool = false) {
        self.username = username
        self.password = password
        self.isRegistered = isRegistered
        self.isAuthenticated = isAuthenticated
    }
}
