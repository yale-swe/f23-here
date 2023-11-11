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
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isRegistered = false
    @Binding var isAuthenticated: Bool
    
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
        }
    }
    
    func LogInUser(){
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
            if let error = error{
                print("error:\(error)")
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP Response")
                return
            }
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Login Response: \(responseString)")
                    }
                    self.isAuthenticated = true;
                }
            }
            // else got error from server
            else {
                if let response = response {
                    print("response:\(response)")
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
