import CoreLocation
import Foundation

struct GPSPoint: Identifiable, Hashable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let horizontalAccuracy: Double
    let speedMetersPerSecond: Double
    let timestamp: Date

    init(location: CLLocation) {
        id = UUID()
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        altitude = location.altitude
        horizontalAccuracy = location.horizontalAccuracy
        speedMetersPerSecond = max(location.speed, 0)
        timestamp = location.timestamp
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var clLocation: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: -1,
            course: -1,
            speed: speedMetersPerSecond,
            timestamp: timestamp
        )
    }
}
