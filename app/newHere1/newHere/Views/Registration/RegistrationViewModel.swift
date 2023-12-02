//
//  RegistrationViewModel.swift
//  newHere
//
//  Created by WD on 2023/12/1.
//

import SwiftUI

class RegistrationViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @State var showingAlert = false
    @State var alertMessage = ""
}
