import SwiftUI

/**
  `ContentView`: The root view of the application.

  Manages user authentication state to toggle between `HomePageView` and `LoginView`.
  - `isAuthenticated`: State variable to track authentication status.
  - `locationDataManager`: Observed object to manage location data.

  View Logic:
  - Displays `HomePageView` with `locationDataManager` if user is authenticated.
  - Shows `LoginView` to handle user authentication otherwise.

  `ContentView_Previews`: Provides a preview of `ContentView` in Xcode.
*/
struct ContentView: View {
    @ObservedObject var authViewModel = AuthViewModel()
    
    @ObservedObject var locationDataManager = LocationDataManager()
    
    @State private var userId: String = ""
    
    /// The body of the view, which conditionally presents either the HomePageView or LoginView based on authentication status.
    var body: some View {
        if authViewModel.isAuthenticated {
                HomePageView()
                    .environmentObject(locationDataManager)
                    .tag("Home")
        } else {
            LoginView(viewModel: authViewModel)
                .tag("Login")
        }
    }
}

/// A preview provider for ContentView, used for rendering the view in Xcode's canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

