//
//  AuthViewModel.swift
//  newHere
//
//  Created by Liyang Wang on 2023/11/20.
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
