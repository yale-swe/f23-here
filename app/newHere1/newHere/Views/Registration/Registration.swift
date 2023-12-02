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
 
    @ObservedObject var viewModel: AuthViewModel

    @ObservedObject var registrationViewModel: RegistrationViewModel = RegistrationViewModel()

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            // User name input section
            Section(header: Text("Name")) {
                TextField("First Name", text: $registrationViewModel.firstName)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("First Name")
                TextField("Last Name", text: $registrationViewModel.lastName)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("Last Name")
            }
            
            // User credentials input section
            Section(header: Text("Credentials")) {
                TextField("Username", text: $registrationViewModel.userName)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("Username")
                TextField("Email", text: $registrationViewModel.email)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("Email")
                SecureField("Password", text: $registrationViewModel.password)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("Password")
                SecureField("Confirm Password", text: $registrationViewModel.confirmPassword)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("Confirm Password")
            }
            
            // Submit button and navigation to login view
            Section {
                
                Button(action: registerUser) {
                    Text("Submit")
                }
                
            } footer: {
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Already have an account? Login")
                        .foregroundStyle(Color.blue)
                        .padding(.top, 20)
                })
            }

        }
        .navigationBarTitle("Registration")
        .alert(isPresented: $registrationViewModel.showingAlert) {
            Alert(title: Text("Registration Status"), message: Text(registrationViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    /// Function to handle user registration
    func registerUser() {
        // Registration logic implementation
        print("User registration logic goes here.")
        // Creating request body
        let requestBody: [String: Any] = [
            "firstName": registrationViewModel.firstName,
            "lastName": registrationViewModel.lastName,
            "userName": registrationViewModel.userName,
            "email": registrationViewModel.email,
            "password": registrationViewModel.password
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
                       registrationViewModel.alertMessage = "Registration failed: \(error.localizedDescription)"
                       registrationViewModel.showingAlert = true
                   } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                       // Success handling
                       registrationViewModel.alertMessage = "Registration successful"
                       registrationViewModel.showingAlert = true
                       viewModel.isRegistered = true
                       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                           presentationMode.wrappedValue.dismiss()
                       })
                   } else {
                       // Failure handling
                       registrationViewModel.alertMessage = "Failed to register. Please try again."
                       registrationViewModel.showingAlert = true
                   }
               }
           }.resume()
    }
}


