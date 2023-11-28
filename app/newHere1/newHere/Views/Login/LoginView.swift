import SwiftUI

// Define the URL and API Key for the login API
let loginUrlString = "https://here-swe.vercel.app/auth/login"
let logApiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

let userId = UserDefaults.standard.string(forKey: "UserId") ?? ""
let userName = UserDefaults.standard.string(forKey: "UserName") ?? ""


/**
 * LoginView
 *
 * Handles user authentication in the application. 
 * It allows users to input their username and password, and to log in to the application. 
 * The view also provides a navigation link to the registration view for new users.
 *
 * Properties:
 * - username, password: State variables to hold user input for authentication.
 * - isRegistered: State variable indicating the registration status of the user.
 * - isAuthenticated: Binding variable to manage authentication status.
 * - showingAlert, alertMessage: State variables for handling alert presentations and messages.
 *
 * Functions:
 * - LogInUser(): Handles the login logic, including validation of user input, preparing the request,
 *   and handling the response from the login API.
 *
 * Note:
 * - Constants like 'loginUrlString' and 'logApiKey' are defined outside the struct for API interaction.
 * - UserDefaults is used for storing user information such as 'UserId' and 'UserName'.
 */
 
struct LoginView: View {
    // User input fields
    @State internal var username: String = ""
    @State internal var password: String = ""
    
    // State variables
    @State internal var isRegistered = false
    @Binding var isAuthenticated: Bool
    
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
    
        /// Function to handle user login
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
                                do {
                                    // Attempt to parse the response data as a JSON object.
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        // Try to extract the user ID from the JSON object.
                                        // The key "_id" should match the key provided in the JSON response.
                                        if let extractedUserId = json["_id"] as? String {
                                            print("User id: \(extractedUserId)")
                                            // Store the extracted user ID in UserDefaults.
                                            UserDefaults.standard.set(extractedUserId, forKey: "UserId")
                                        }
                                        
                                        // Similarly, try to extract the user's username from the JSON object.
                                        if let userName = json["userName"] as? String {
                                            print("User Name:\(userName)")
                                            // Store the extracted username in UserDefaults.
                                            UserDefaults.standard.set(userName, forKey: "UserName")
                                        }
                                    }
                                } catch {
                                    // If JSON parsing fails, print an error message.
                                    print("Error parsing JSON: \(error)")
                                }
                                self.isAuthenticated = true
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
