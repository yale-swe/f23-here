//
//  LoginView.swift
//  newHere
//
//  Created by TRACY LI on 2023/11/7.
//
//  Description:
//  This Swift file defines the LoginView, which is responsible for user login in the 'newHere' application.
//  It includes input fields for username and password, and login logic to communicate with a remote server.
//

import SwiftUI

// Define the URL and API Key for the login API
let loginUrlString = "https://here-swe.vercel.app/auth/login"
let logApiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

struct LoginView: View {
    // User input fields
    @State internal var username: String = ""
    @State internal var password: String = ""
    
    // State variables
    @State internal var isRegistered = false
    @Binding var isAuthenticated: Bool
    @Binding var user_id: String
    
    // Alert properties to display login status
    @State internal var showingAlert = false
    @State internal var alertMessage = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 50)
                
                // Username input field
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                // Password input field
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                // Login button
                Button(action: LogInUser) {
                    Text("Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                .padding(.horizontal)
                
                // Navigation link to registration view
                NavigationLink(destination: RegistrationView(isRegistered: $isRegistered, userId: $user_id)) {
                    Text("Don't have an account? Signup")
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Login Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
        // Function to handle user login
        func LogInUser(){
            if username.isEmpty || password.isEmpty {
                self.alertMessage = "Please enter both username and password."
                self.showingAlert = true
                return
            }
            
            print("Login user called")
            
            // Prepare the request body with user input
            let requestBody: [String: Any] = [
                "inputLogin": username,
                "password": password]
            
            // Convert the request body to JSON data
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
            else{
                return
            }
            
            // Create the URL for the login API
            guard let url = URL(string: loginUrlString) else {
                return
            }
            
            // Create a URLRequest for the API request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(logApiKey, forHTTPHeaderField: "x-api-key")
                    
            // Perform the network request
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error{
                        // Handle network error
                        self.alertMessage = "Login failed: \(error.localizedDescription)"
                        self.showingAlert = true
                    }else if let httpResponse = response as? HTTPURLResponse{
                        let statusCode = httpResponse.statusCode
                        if statusCode == 200 {
                            if let data = data {
                                if let responseString = String(data: data, encoding: .utf8) {
                                    print("Login Response: \(responseString)")

                                    if let jsonData = responseString.data(using: .utf8) {
                                    do {
                                        if let json = try JSONSerialization.jsonObject(with: jsonData, options:[]) as? [String: Any],
                                           let extractedUserId = json["_id"] as? String {
                                            print("User id: \(extractedUserId)")
                                            // Extract and store user ID
                                            self.user_id = extractedUserId;
                                            print("updated: \(self.user_id)")
                                           UserDefaults.standard.set(extractedUserId, forKey: "UserId")
//                                            self.isAuthenticated = true;
                                       }
                                        
                                        if let json = try JSONSerialization.jsonObject(with: jsonData, options:[]) as? [String: Any],
                                        let userName = json["userName"] as? String {
                                            print("User Name:\(userName)")
                                            // Store user's username
                                            UserDefaults.standard.set(userName, forKey: "UserName")
                                        }
                                    } catch {
                                        print("Error parsing JSON: \(error)")
                                    }
                                }
                                }
                                // Set the user as authenticated
                                self.isAuthenticated = true;
                                print("authenticated: \(self.isAuthenticated)")
                                print("user_id: \(self.user_id)")
                            }
                        }else if statusCode == 404 {
                            // Handle user not found
                            self.alertMessage = "User not found. Please check your credentials."
                            self.showingAlert = true
                        }else{
                            // Handle other server errors
                            self.alertMessage = "Login failed: Server returned status code \(httpResponse.statusCode)"
                            self.showingAlert = true
                        }
                    }else{
                        // Handle unexpected errors
                        self.alertMessage = "Login failed: Unexpected error occurred"
                        self.showingAlert = true
                    }
                }
                
            }.resume()
            
        }
        
}
