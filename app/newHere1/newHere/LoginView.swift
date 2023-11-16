//
//  LoginView.swift
//  newHere
//
//  Created by TRACY LI on 2023/11/7.
//

import SwiftUI

let loginUrlString = "https://here-swe.vercel.app/auth/login"
let logApiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

struct LoginView: View {
    @State internal var username: String = ""
    @State internal var password: String = ""
    @State internal var isRegistered = false
    @Binding var isAuthenticated: Bool
    
    @State internal var showingAlert = false
    @State internal var alertMessage = ""
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 50)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
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
                
                NavigationLink(destination: RegistrationView(isRegistered: $isRegistered)) {
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
        
        func LogInUser(){
            if username.isEmpty || password.isEmpty {
                self.alertMessage = "Please enter both username and password."
                self.showingAlert = true
                return
            }
            
            print("Login user called")
            let requestBody: [String: Any] = [
                "inputLogin": username,
                "password": password]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)
            else{
                return
            }
            
            guard let url = URL(string: loginUrlString) else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(logApiKey, forHTTPHeaderField: "x-api-key")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error{
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
                                        let userId = json["_id"] as? String {
                                            print("User ID:\(userId)")
                                            UserDefaults.standard.set(userId, forKey: "UserId")
                                        }
                                        
                                        if let json = try JSONSerialization.jsonObject(with: jsonData, options:[]) as? [String: Any],
                                        let userName = json["userName"] as? String {
                                            print("User Name:\(userName)")
                                            UserDefaults.standard.set(userName, forKey: "UserName")
                                        }
                                    } catch {
                                        print("Error parsing JSON: \(error)")
                                    }
                                }
                                }
                                self.isAuthenticated = true;
                            }
                        }else if statusCode == 404 {
                            self.alertMessage = "User not found. Please check your credentials."
                            self.showingAlert = true
                        }else{
                            self.alertMessage = "Login failed: Server returned status code \(httpResponse.statusCode)"
                            self.showingAlert = true
                        }
                    }else{
                        // General error
                        self.alertMessage = "Login failed: Unexpected error occurred"
                        self.showingAlert = true
                    }
                }
                
            }.resume()
            
        }
        
}
//// Preview Provider
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(isAuthenticated: $isAuthenticated)
//    }
//}
