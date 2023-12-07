//
//  PhotoLibraryManager.swift
//  newHere
//
//  Created by TRACY LI on 2023/12/2.
//

import UIKit
import Photos

class ImageSaver: NSObject {
    var completion: ((Bool, Error?) -> Void)?

    func saveImageToAlbum(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completion?(false, error)
        } else {
            completion?(true, nil)
        }
    }
}

struct PhotoLibraryManager {
    static func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        @unknown default:
            fatalError("Unknown photo library authorization status")
        }
    }
}

