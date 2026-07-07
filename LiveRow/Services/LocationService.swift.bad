import CoreLocation
import Foundation

enum GPSStatus: Equatable {
    case notDetermined
    case denied
    case searching
    case weak
    case ready

    var displayName: String {
        switch self {
        case .notDetermined:
            "Permission Needed"
        case .denied:
            "GPS Denied"
        case .searching:
            "Searching"
        case .weak:
            "Weak GPS"
        case .ready:
            "GPS Ready"
        }
    }
}

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var currentSpeedMetersPerSecond: Double = 0
    @Published private(set) var totalDistanceMeters: Double = 0
    @Published private(set) var latestPoint: GPSPoint?
    @Published private(set) var gpsStatus: GPSStatus = .notDetermined
    @Published private(set) var points: [GPSPoint] = []

    private let manager = CLLocationManager()
    private var lastAcceptedLocation: CLLocation?

    private let maximumHorizontalAccuracy: CLLocationAccuracy = 25
    private let maximumReasonableSegmentMeters: CLLocationDistance = 100

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()

        manager.delegate = self
        manager.activityType = .fitness
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 1
        manager.pausesLocationUpdatesAutomatically = false

        updateGPSStatus(for: authorizationStatus)
    }

    func requestAuthorizationIfNeeded() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            gpsStatus = .searching
        case .denied, .restricted:
            gpsStatus = .denied
        @unknown default:
            gpsStatus = .denied
        }
    }

    func startTracking() {
        requestAuthorizationIfNeeded()

        guard isAuthorized else { return }
        gpsStatus = .searching
        manager.startUpdatingLocation()
    }

    func pauseTracking() {
        manager.stopUpdatingLocation()
        currentSpeedMetersPerSecond = 0
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
        reset()
    }

    func reset() {
        currentSpeedMetersPerSecond = 0
        totalDistanceMeters = 0
        latestPoint = nil
        lastAcceptedLocation = nil
        points.removeAll()
        updateGPSStatus(for: manager.authorizationStatus)
    }

    private var isAuthorized: Bool {
        manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
    }

    private func process(location: CLLocation) {
        guard location.horizontalAccuracy >= 0 else { return }

        if location.horizontalAccuracy > maximumHorizontalAccuracy {
            gpsStatus = .weak
            return
        }

        let point = GPSPoint(location: location)
        gpsStatus = .ready
        latestPoint = point
        points.append(point)

        if let lastAcceptedLocation {
            let segmentDistance = location.distance(from: lastAcceptedLocation)
            if segmentDistance <= maximumReasonableSegmentMeters {
                totalDistanceMeters += segmentDistance
            }
        }

        lastAcceptedLocation = location

        // CoreLocation reports invalid GPS speed as a negative value; those samples are ignored.
        if location.speed >= 0 {
            currentSpeedMetersPerSecond = location.speed
        }
    }

    private func updateGPSStatus(for status: CLAuthorizationStatus) {
        authorizationStatus = status

        switch status {
        case .notDetermined:
            gpsStatus = .notDetermined
        case .restricted, .denied:
            gpsStatus = .denied
        case .authorizedAlways, .authorizedWhenInUse:
            gpsStatus = .searching
        @unknown default:
            gpsStatus = .denied
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        Task { @MainActor [weak self, status] in
            guard let self else { return }

            updateGPSStatus(for: status)
            if isAuthorized {
                self.manager.startUpdatingLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in
            process(location: location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            gpsStatus = .weak
        }
    }
}
