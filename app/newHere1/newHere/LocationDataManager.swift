import CoreLocation
import Combine

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
