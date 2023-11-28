import SwiftUI
import ARKit

/**
 * CustomARViewRepresentable
 *
 * A SwiftUI view representable integrating ARKit's ARSCNView into a SwiftUI view context. 
 * It facilitates augmented reality features, specifically focusing on rendering messages as 3D objects within an AR environment.
 * The struct uses environment objects to manage state related to messages and interacts with ARKit for real-time AR functionalities.
 *
 * Key Functions:
 * - makeUIView(context:): Configures and returns an ARSCNView for AR content rendering.
 * - updateUIView(_:context:): Updates the AR view when new messages are available.
 * - makeCoordinator(): Creates a coordinator for handling ARSCNViewDelegate methods.
 * - plantBubbleNode(to:message:): Plants a bubble node with a message in the AR scene.
 * - renderBubbleNodeHistory(to:messages:): Renders a history of messages as bubble nodes in random positions.
 * - newBubbleNode(to:message:position:): Creates a new bubble node with a message at a specified position.
 */
struct CustomARViewRepresentable: UIViewRepresentable {
    // Environment objects for message and fetched messages states
    @EnvironmentObject var messageState: MessageState
    @EnvironmentObject var fetchedMessagesState: FetchedMessagesState
    @EnvironmentObject var locationDataManager: LocationDataManager
    
    /// Create the ARSCNView and configure it
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        print("user id: \(userId)")
        
        var friendIdList: [String] = []
        // Fetch and render user's messages
        getAllUserFriends(userId: userId) { result in
            switch result {
            case .success(let response):
                print("Friends fetched successfully: \(response)")
                friendIdList = response.keys.map { $0 }
                
            case .failure(let error):
                print("Error getting friends: \(error.localizedDescription)")
            }
        }
        
        if let currentLocation = locationDataManager.location {
            getFilteredMessages(userId: userId, location: currentLocation, friendList: friendIdList) {
                result in
                switch result {
                case .success(let response):
                    print("Messages filtered successfully: \(response)")
                    var convertedMessages:[Message] = response
                    fetchedMessagesState.fetchedMessages = convertedMessages
                    print("fetched messages: \(fetchedMessagesState.fetchedMessages)")
                    renderBubbleNodeHistory(to: sceneView, messages: convertedMessages)
                    
                case .failure(let error):
                    print("Error getting messages: \(error.localizedDescription)")
                }
            }
        }
        
        
        return sceneView
    }
    
    /// Update the AR view when a new message is available
    func updateUIView (_ uiView: ARSCNView, context: Context) {
        if let messageToPlant = messageState.currentMessage {
            plantBubbleNode(to: uiView, message: messageToPlant)
            messageState.currentMessage = nil
        }
        
    }
    
    /// Create a coordinator for handling ARSCNViewDelegate methods
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
    }
    
    /// A coordinator class that acts as a delegate for `ARSCNView`.
    /// It is used to bridge UIKit with SwiftUI by coordinating with `CustomARViewRepresentable`.
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: CustomARViewRepresentable
        
        init(_ parent: CustomARViewRepresentable) {
            self.parent = parent
        }
    }
    
    /// Plant a bubble node with a message at a specific position
    func plantBubbleNode(to sceneView: ARSCNView, message: Message) {
        // Set the position based on the provided position
        if let frame = sceneView.session.currentFrame {
            let transform = frame.camera.transform

            // Get the camera's forward direction (z-axis)
            let forwardDirection = SCNVector3(-transform.columns.2.x, -transform.columns.2.y, -transform.columns.2.z)

            // Calculate the position 2 meters in front of the camera
            let shifted_position = SCNVector3(
                transform.columns.3.x + forwardDirection.x * 0.5,
                transform.columns.3.y + forwardDirection.y * 0.5,
                transform.columns.3.z + forwardDirection.z * 0.5
            )
            
            newBubbleNode(to: sceneView, message: message, position: shifted_position)
        }
    }
    
    /// Render a history of bubble nodes with messages at random positions
    func renderBubbleNodeHistory(to sceneView: ARSCNView, messages: [Message]) {
        // Create a random number generator
        var randomNumberGenerator = SystemRandomNumberGenerator()

        // Define the range of random positions for x, y, and z coordinates
        let xRange: ClosedRange<Float> = -2.0...2.0  // Represents a 4-meter width (-2m to +2m)
        let yRange: ClosedRange<Float> = -1.0...2.0   // Represents a height range above the ground (-1m to +2m)
        let zRange: ClosedRange<Float> = -2.0...2.0  // Represents a 4-meter depth (-2m to +2m)

        for message in messages {
            // Generate random positions
            let randomX = Float.random(in: xRange, using: &randomNumberGenerator)
            let randomY = Float.random(in: yRange, using: &randomNumberGenerator)
            let randomZ = Float.random(in: zRange, using: &randomNumberGenerator)

            // Create an SCNVector3 using the random positions
            let randomPosition = SCNVector3(randomX, randomY, randomZ)
            
            newBubbleNode(to: sceneView, message: message, position: randomPosition)
        }
    }
    
    /// Creates an animation sequence from a series of textures.
    /// - Returns: A `SKAction` representing the continuous animation.
    func createSpriteAnimation() -> SKAction {
        let textureAtlas = SKTextureAtlas(named: "BubbleAnimation")
        var frames: [SKTexture] = []

        let numImages = textureAtlas.textureNames.count
        print("Number of images in atlas: \(numImages)") // Debugging statement

        textureAtlas.textureNames.forEach { print($0) } // Print each texture name

        for i in 0..<numImages {
            let textureName = "bubble-final\(String(format: "%04d", i))"
            let texture = textureAtlas.textureNamed(textureName)
            frames.append(texture)
        }

        if frames.isEmpty {
            print("No frames loaded, check texture names and formats") // Debugging statement
        }

        return SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.1))
    }
    
    /// Creates a scene with an animated sprite centered in it.
    /// - Returns: A `SKScene` containing the animated sprite.
    func createAnimatedSpriteScene() -> SKScene {
        let spriteSize = CGSize(width: 1000, height: 1000)  // Adjust the size as needed
        let spriteScene = SKScene(size: spriteSize)
        spriteScene.backgroundColor = .clear

        let spriteNode = SKSpriteNode(color: .clear, size: spriteSize)
        spriteNode.position = CGPoint(x: spriteScene.size.width / 2, y: spriteScene.size.height / 2)
        spriteScene.addChild(spriteNode)

        spriteNode.run(createSpriteAnimation())

        return spriteScene
    }

    /// Create a new bubble node with a message at a specified position
    func newBubbleNode(to sceneView: ARSCNView, message:Message, position:SCNVector3) {
        let plane = SCNPlane(width: 0.2, height: 0.2)  // Adjust size as needed
        plane.firstMaterial?.diffuse.contents = createAnimatedSpriteScene()
        plane.firstMaterial?.isDoubleSided = true
        let bubbleNode = SCNNode(geometry: plane)
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = .Y // Adjusts the node to always face the camera, but only rotates on its Y-axis
        bubbleNode.constraints = [billboardConstraint]
        
        // Create an SCNText geometry for the first text
        let textGeometry1 = SCNText(string: message.id, extrusionDepth: 0.001)
        textGeometry1.firstMaterial?.diffuse.contents = UIColor.black
        let textNode1 = SCNNode(geometry: textGeometry1)
        
        // Position the first textNode inside the bubble
        textNode1.position = SCNVector3(-0.05, 0, -0.05) // Adjust the position inside the bubble
        textNode1.scale = SCNVector3(0.001, 0.001, 0.001)

        // Create an SCNText geometry for the second text
        let textGeometry2 = SCNText(string: message.messageStr, extrusionDepth: 0.001)
        textGeometry2.firstMaterial?.diffuse.contents = UIColor.black
        let textNode2 = SCNNode(geometry: textGeometry2)

        // Position the second textNode inside the bubble, stacked on top of the first
        textNode2.position = SCNVector3(-0.05, 0, 0.05) // Adjust the vertical position inside the bubble
        textNode2.scale = SCNVector3(0.001, 0.001, 0.001)

        // Add both text nodes as children of the bubbleNode
        //bubbleNode.addChildNode(textNode1)
        bubbleNode.addChildNode(textNode2)

        print("\(message.id), \(message.messageStr)")
        // Set the node's position to the calculated position 2 meters in front of the camera
        bubbleNode.position = position
        sceneView.scene.rootNode.addChildNode(bubbleNode)
    }
}
