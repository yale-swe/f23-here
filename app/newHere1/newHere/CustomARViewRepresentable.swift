//
//  CustomARViewRepresentable.swift
//  new_here
//
//  Created by TRACY LI on 2023/10/28.
//

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView()
    }
    
    func updateUIView (_ uiView: CustomARView, context: Context) {}
}
