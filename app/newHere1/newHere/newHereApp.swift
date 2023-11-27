/**
 * newHereApp
 *
 * The main struct for the 'newHere' SwiftUI application, marked with @main to indicate the entry point of the app.
 * It defines the body of the app with a scene configuration.
 *
 * Scene Configuration:
 * - WindowGroup: A container that defines the content of the app's primary window. 
 *   It initializes ContentView as the root view of the application.
 */
 
import SwiftUI

@main
struct newHereApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
