//
//  Registration.swift
//  newHere
//
//  Created by TRACY LI on 2023/11/4.
//
//  Description:
//  This file defines the RegistrationView, which is used for user registration in the 'newHere' application.
//  It includes form inputs for user details and a registration logic to communicate with a remote server.

import SwiftUI

// URL and API Key for registration API
let registerUrlString = "https://here-swe.vercel.app/auth/register"
let regApiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

/// View for user registration.
struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Binding var isRegistered: Bool
    @Binding var userId: String
    @State private var isAuthenticated = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                // User name input section
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                        .disableAutocorrection(true)
                    TextField("Last Name", text: $lastName)
                        .disableAutocorrection(true)
                }
                
                // User credentials input section
                Section(header: Text("Credentials")) {
                    TextField("Username", text: $userName)
                        .disableAutocorrection(true)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .disableAutocorrection(true)
                }
                
                // Submit button and navigation to login view
                Section {
                    Button(action: registerUser) {
                        Text("Submit")
                    }
              
                    NavigationLink(destination: LoginView(isAuthenticated: $isAuthenticated, user_id: $userId)) {
                        Text("Already have an account? Login")
                    }
                }
            }
            .navigationBarTitle("Registration")
            .alert(isPresented: $showingAlert){
                Alert(title: Text("Registration Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Function to handle user registration
    func registerUser() {
        // Registration logic implementation
        print("User registration logic goes here.")
        // Creating request body
        let requestBody: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "userName": userName,
            "email": email,
            "password": password
        ]
        
        // Converting request body to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
        else {
            return
        }
        
        // Creating URL and URLRequest
        guard let url = URL(string: registerUrlString) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(regApiKey, forHTTPHeaderField: "x-api-key")
        
        // Performing the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   // Handling the response
                   if let error = error {
                       self.alertMessage = "Registration failed: \(error.localizedDescription)"
                       self.showingAlert = true
                   } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                       // Success handling
                       self.alertMessage = "Registration successful"
                       self.showingAlert = true
                       self.isRegistered = true
                   } else {
                       // Failure handling
                       self.alertMessage = "Failed to register. Please try again."
                       self.showingAlert = true
                   }
               }
           }.resume()
    }
}


