//
//  CustomARView.swift
//  new_here
//
//  Created by TRACY LI on 2023/10/28.
//

import ARKit
import RealityKit
import SwiftUI

class CustomARView: ARView {
    required init (frame frameRect: CGRect){
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: UIScreen.main.bounds)
    }
}
