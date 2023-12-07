//
//  ScreenshotUtility.swift
//  newHere
//
//  Created by TRACY LI on 2023/12/2.
//

import UIKit

func captureScreenshot(of view: UIView) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
    return renderer.image { ctx in
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    }
}

