import ARKit
import RealityKit
import SwiftUI

/**
 * CustomARView Class
 *
 * This class extends ARView to provide custom Augmented Reality (AR) experiences.
 * It includes initializers for setting up the view with a specific frame or using the device's main screen bounds.
 *
 * Methods:
 * 1. init(frame: CGRect): Initializes the view with a specified frame.
 * 2. init(coder: NSCoder): Required initializer for decoding, not implemented.
 * 3. init(): Convenience initializer that sets up the view using the main screen bounds.
 */
class CustomARView: ARView {
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    required init (frame frameRect: CGRect){
        super.init(frame: frameRect)
    }
    
    /// Returns an object initialized from data in a given unarchiver.
    dynamic required init?(coder decoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Convenience initializer to create a view with the main screen bounds.
    convenience init(){
        self.init(frame: UIScreen.main.bounds)
    }
}
