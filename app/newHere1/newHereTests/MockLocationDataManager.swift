//
//  MockLocationDataManager.swift
//  newHereTests_v2
//
//  Created by Liyang Wang on 11/27/23.
//

import CoreLocation
import Foundation
@testable import newHere

class MockLocationDataManager: LocationDataManager {
    var currentLocation: CLLocation?
    var fetchLocationResult: Result<CLLocation, Error>?

    init(currentLocation: CLLocation? = CLLocation(latitude: 0.0, longitude: 0.0)) {
        self.currentLocation = currentLocation
    }
    func mockFetchLocationSuccess(location: CLLocation) {
        fetchLocationResult = .success(location)
    }
    func mockFetchLocationFailure(error: Error) {
        fetchLocationResult = .failure(error)
    }

    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        if let result = fetchLocationResult {
            completion(result)
        } else {
            completion(.success(currentLocation ?? CLLocation()))
        }
    }

    struct MockError: Error {
        var errorDescription: String?
    }
}
