//
//  Registration.swift
//  newHere
//
//  Created by TRACY LI on 2023/11/4.
//

import SwiftUI

let registerUrlString = "https://here-swe.vercel.app/auth/register"
let regApiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

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
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                        .disableAutocorrection(true)
                    TextField("Last Name", text: $lastName)
                        .disableAutocorrection(true)
                }
                
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
        request.setValue(regApiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       self.alertMessage = "Registration failed: \(error.localizedDescription)"
                       self.showingAlert = true
                   } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                       // Assuming status code 200 means success
                       self.alertMessage = "Registration successful"
                       self.showingAlert = true
                       self.isRegistered = true
                   } else {
                       self.alertMessage = "Failed to register. Please try again."
                       self.showingAlert = true
                   }
               }
           }.resume()
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error{
//                print("error:\(error)")
//            }
//            if let response = response {
//                print("response:\(response)")
//            }
//            if let data = data {
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Response: \(responseString)")
//                }
//                self.isRegistered = true
//            }
//        }.resume()
        
    }
}

//struct RegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegistrationView()
//    }
//}
