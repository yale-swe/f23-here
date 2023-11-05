//
//  CustomARViewRepresentable.swift
//  new_here
//
//  Created by TRACY LI on 2023/10/28.
//

import SwiftUI
import ARKit

//class ARViewModel: ObservableObject {
//    var messageToPlant: Message?
//    
//    func plantMessage(_ message: Message) {
//        messageToPlant = message
//    }
//}

struct CustomARViewRepresentable: UIViewRepresentable {
    @EnvironmentObject var messageState: MessageState
    
    func makeUIView(context: Context) -> ARSCNView {
//        return CustomARView()
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        return sceneView
    }
    
    func updateUIView (_ uiView: ARSCNView, context: Context) {
        if let messageToPlant = messageState.currentMessage {
            plantBubbleNode(to: uiView, message: messageToPlant)
            messageState.currentMessage = nil
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
    }
        
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: CustomARViewRepresentable
        
        init(_ parent: CustomARViewRepresentable) {
            self.parent = parent
        }
    }
    
    func plantBubbleNode(to sceneView: ARSCNView, message: Message) {
        let bubble = SCNSphere(radius: 0.05)
        bubble.firstMaterial?.diffuse.contents = UIColor(red: 135.0/255.0, green: 206.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        let bubbleNode = SCNNode(geometry: bubble)
        // Set the position based on the provided position
        if let frame = sceneView.session.currentFrame {
            let transform = frame.camera.transform

            // Get the camera's forward direction (z-axis)
            let forwardDirection = SCNVector3(-transform.columns.2.x, -transform.columns.2.y, -transform.columns.2.z)

            // Calculate the position 2 meters in front of the camera
            let position = SCNVector3(
                transform.columns.3.x + forwardDirection.x * 0.5,
                transform.columns.3.y + forwardDirection.y * 0.5,
                transform.columns.3.z + forwardDirection.z * 0.5
            )

            // Create an SCNText geometry for the first text
            let textGeometry1 = SCNText(string: message.author, extrusionDepth: 0.001)
            textGeometry1.firstMaterial?.diffuse.contents = UIColor.black
            let textNode1 = SCNNode(geometry: textGeometry1)
            
            
            // TEXT POSITIONING RELATIVE TO BUBBLE - WILL HAVE TO ADJUST LATER
            
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
            bubbleNode.addChildNode(textNode1)
            bubbleNode.addChildNode(textNode2)

            print("\(message.author), \(message.messageStr)")
            // Set the node's position to the calculated position 2 meters in front of the camera
            bubbleNode.position = position
        }

        
        sceneView.scene.rootNode.addChildNode(bubbleNode)
    }
        
}
