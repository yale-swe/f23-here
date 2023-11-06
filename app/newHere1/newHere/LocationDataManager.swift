import CoreLocation
import Combine

enum GeoJSONError: Error {
    case invalidType
    case invalidCoordinates
}

struct GeoJSONPoint: Codable {
    let type: String
    let coordinates: [Double]
    
    init (latitude: Double, longitude: Double) {
        self.type = "Point"
        self.coordinates = [longitude, latitude]
    }
    
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
    func toGeoJSONPoint() -> GeoJSONPoint {
        return GeoJSONPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}

class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private var locationManager = CLLocationManager()

    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.location = newLocation
        }
    }
}

