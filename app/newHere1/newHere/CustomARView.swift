//
//  CustomARView.swift
//  new_here
//
//  Created by TRACY LI on 2023/10/28.
//
//  Description:
//  This file defines a CustomARView class, which is a subclass of ARView from RealityKit.
//  It's designed to be used for augmented reality experiences within the 'new_here' application.

import ARKit
import RealityKit
import SwiftUI

/// CustomARView is a subclass of ARView for creating custom AR experiences.
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
