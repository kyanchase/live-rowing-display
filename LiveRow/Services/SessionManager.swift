import Combine
import Foundation

enum SessionState: Equatable {
    case idle
    case active
    case paused
}

@MainActor
final class SessionManager: ObservableObject {
    @Published private(set) var state: SessionState = .idle
    @Published private(set) var activeSession = RowSession()

    let locationService: LocationService
    let timerService: TimerService

    private var cancellables = Set<AnyCancellable>()

    init(locationService: LocationService, timerService: TimerService) {
        self.locationService = locationService
        self.timerService = timerService

        bindServices()
    }

    var elapsedTime: TimeInterval {
        timerService.elapsedTime
    }

    var distanceMeters: Double {
        locationService.totalDistanceMeters
    }

    var currentSpeedMetersPerSecond: Double {
        locationService.currentSpeedMetersPerSecond
    }

    var currentSplitSeconds: TimeInterval? {
        SplitCalculator.splitSeconds(for: currentSpeedMetersPerSecond)
    }

    var averageSplitSeconds: TimeInterval? {
        SplitCalculator.averageSplitSeconds(
            distanceMeters: distanceMeters,
            elapsedTime: elapsedTime
        )
    }

    var gpsStatus: GPSStatus {
        locationService.gpsStatus
    }

    func startSession() {
        activeSession = RowSession(startedAt: Date())
        locationService.reset()
        locationService.startTracking()
        timerService.reset()
        timerService.start()
        state = .active
    }

    func pauseSession() {
        switch state {
        case .active:
            timerService.pause()
            locationService.pauseTracking()
            state = .paused
        case .paused:
            locationService.startTracking()
            timerService.start()
            state = .active
        case .idle:
            break
        }
    }

    func stopSession() {
        activeSession.endedAt = Date()
        activeSession.elapsedTime = elapsedTime
        activeSession.distanceMeters = distanceMeters
        activeSession.maximumSpeedMetersPerSecond = max(
            activeSession.maximumSpeedMetersPerSecond,
            currentSpeedMetersPerSecond
        )
        activeSession.gpsPoints = locationService.points

        timerService.reset()
        locationService.stopTracking()
        state = .idle
    }

    private func bindServices() {
        locationService.$currentSpeedMetersPerSecond
            .sink { [weak self] speed in
                guard let self else { return }
                activeSession.maximumSpeedMetersPerSecond = max(
                    activeSession.maximumSpeedMetersPerSecond,
                    speed
                )
            }
            .store(in: &cancellables)
    }
}
