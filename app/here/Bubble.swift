//
//  Bubble.swift
//  here
//
//  Created by Eric  Wang on 10/28/23.
//

import Foundation
import ARKit

class Bubble: SCNNode {
    
    override init() {
        super.init()
        let bubble = SCNPlane(width: 0.25, height: 0.25)
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "bubbleText")
        material.isDoubleSided = true
        material.writesToDepthBuffer = false
        material.blendMode = .screen
        bubble.materials = [material]
        self.geometry = bubble
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
