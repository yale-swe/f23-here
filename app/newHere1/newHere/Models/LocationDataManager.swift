import CoreLocation
import Combine

/**
 * GeoJSONError
 *
 * Used to represent specific error conditions
 * encountered when working with GeoJSON data, particularly during validation or conversion processes.
 *
 * Cases:
 * - invalidType: Indicates an error due to an invalid or unexpected GeoJSON type.
 * - invalidCoordinates: Signifies an error when GeoJSON coordinates are invalid, missing, or malformed.
 */
enum GeoJSONError: Error {
    case invalidType
    case invalidCoordinates
}

/**
 * GeoJSONPoint
 *
 * Represents a GeoJSON Point with latitude and longitude coordinates. It provides a method to convert to CLLocation and is 
 * Codable for easy serialization/deserialization.
 *
 * Properties:
 * - type: A String representing the GeoJSON type, typically "Point".
 * - coordinates: An array of Doubles representing latitude and longitude.
 *
 * Initializer:
 * - Initializes a GeoJSONPoint with latitude and longitude, setting the type to "Point".
 *
 * Functions:
 * - toCLLocation(): Converts a GeoJSONPoint to a CLLocation object, validating the type and coordinates format.
 */
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

/**
 * CLLocation Extension
 *
 * Adds functionality to the CLLocation class to support conversion to a GeoJSONPoint. This extension enriches CLLocation objects
 * with the ability to be easily transformed into a GeoJSON compatible format.
 *
 * Functions:
 * - toGeoJSONPoint(): Converts a CLLocation instance to a GeoJSONPoint, enabling CLLocation objects to be represented in the GeoJSON format.
 */
extension CLLocation {
    // Convert CLLocation to GeoJSONPoint
    func toGeoJSONPoint() -> GeoJSONPoint {
        return GeoJSONPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}

/**
 * LocationDataManager
 *
 * Manages location-related data and updates using Core Location. This class is responsible for handling Core Location updates
 * and converting location data to/from GeoJSON format. It uses Combine's @Published property to provide observable location updates.
 *
 * Properties:
 * - location: A published property representing the current CLLocation.
 * - locationManager: An instance of CLLocationManager for managing location updates.
 *
 * Initializer:
 * - Initializes a new LocationDataManager object, setting up the CLLocationManager and starting location updates.
 *
 * Functions:
 * - locationManager(_:didUpdateLocations:): A delegate method called when location updates occur, updating the location property.
 */
class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private var locationManager = CLLocationManager()

    /// Initialize LocationDataManager and set up CLLocationManager
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    /// CLLocationManagerDelegate method called on location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.location = newLocation
        }
    }
}

