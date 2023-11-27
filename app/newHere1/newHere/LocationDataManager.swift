// Description:  LocationDataManager Class: Manages location-related data and updates using Core Location. Converts location data to/from GeoJSON format.

//GeoJSONPoint Struct: Represents a GeoJSON Point with latitude and longitude coordinates. Provides conversion to CLLocation.
//
//CLLocation Extension: Adds a method to convert CLLocation to GeoJSONPoint.

import CoreLocation
import Combine

enum GeoJSONError: Error {
    case invalidType
    case invalidCoordinates
}

// This Codable struct represents a GeoJSON Point with latitude and longitude coordinates.

//Properties:
//- type: String representing the GeoJSON type (e.g., "Point").
//- coordinates: Array of Doubles representing latitude and longitude.
//
//Initializer:
//- Initializes a GeoJSONPoint with latitude and longitude, setting the type to "Point".
//
//Functions:
//- toCLLocation(): Converts GeoJSONPoint to CLLocation.

struct GeoJSONPoint: Codable {
    let type: String
    let coordinates: [Double]
    
    // Initialize GeoJSONPoint with latitude and longitude
    init (latitude: Double, longitude: Double) {
        self.type = "Point"
        self.coordinates = [longitude, latitude]
    }
    
    // Convert GeoJSONPoint to CLLocation
    func toCLLocation() throws -> CLLocation {
        guard type == "Point" else {
            throw GeoJSONError.invalidType
        }
        guard coordinates.count == 2 else {
            throw GeoJSONError.invalidCoordinates
        }
        return CLLocation(latitude: coordinates[1], longitude: coordinates[0])
    }
}

extension CLLocation {
    // Convert CLLocation to GeoJSONPoint
    func toGeoJSONPoint() -> GeoJSONPoint {
        return GeoJSONPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}

//  This class manages location-related data and interactions, including handling Core Location updates and converting location data to/from GeoJSON format.

//Properties:
//- location: Published property representing the current CLLocation.
//- locationManager: CLLocationManager instance for managing location updates.
//
//Initializer:
//- Initializes a new LocationDataManager object, setting up the CLLocationManager and starting location updates.
//
//Functions:
//- locationManager(_:didUpdateLocations:): Delegate method called when location updates occur, updating the location property.

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private var locationManager = CLLocationManager()

    // Initialize LocationDataManager and set up CLLocationManager
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method called on location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.location = newLocation
        }
    }
}

