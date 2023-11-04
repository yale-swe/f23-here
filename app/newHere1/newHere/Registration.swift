//
//  Registration.swift
//  newHere
//
//  Created by TRACY LI on 2023/11/4.
//

import SwiftUI

let registerUrlString = "https://here-swe.vercel.app/auth/register"
let apiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Binding var isRegistered: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                
                Section(header: Text("Credentials")) {
                    TextField("Username", text: $userName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                Section {
                    Button(action: registerUser) {
                        Text("Submit")
                    }
                }
            }
            .navigationBarTitle("Registration")
        }
    }

    func registerUser() {
        // Implement registration logic
        print("User registration logic goes here.")
        let requestBody: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "userName": userName,
            "email": email,
            "password": password
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        else {
            return
        }

        guard let url = URL(string: registerUrlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in }.resume()
        self.isRegistered = true
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(isRegistered: self.isRegistered)
    }
}
