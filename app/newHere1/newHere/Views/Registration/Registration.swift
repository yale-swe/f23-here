import SwiftUI

// URL and API Key for registration API
let registerUrlString = "https://here-swe.vercel.app/auth/register"
let regApiKey = "qe5YT6jOgiA422_UcdbmVxxG1Z6G48aHV7fSV4TbAPs"

/**
 * RegistrationView
 *
 * A SwiftUI view for user registration. It provides text fields for entering personal details and credentials, 
 * and includes a submission button to register the user. This view also handles the registration logic, 
 * including data validation and network requests to the registration API.
 *
 * Properties:
 * - firstName, lastName, userName, email, password, confirmPassword: State variables for user input.
 * - isRegistered: Binding to track the registration status.
 * - isAuthenticated: State to manage authentication status.
 * - showingAlert, alertMessage: State variables for alert presentation and messages.
 *
 * Functions:
 * - registerUser(): Handles the registration process, including validating input, creating a request body, 
 *   and making a network request to the registration API.
 */
struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @Binding var isRegistered: Bool
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
              
                    NavigationLink(destination: LoginView(isAuthenticated: $isAuthenticated)) {
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
    
    /// Function to handle user registration
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


