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
    @Published private(set) var completedSessions: [RowSession]

    let locationService: LocationService
    let motionService: MotionService
    let timerService: TimerService

    private var cancellables = Set<AnyCancellable>()

    init(locationService: LocationService, motionService: MotionService, timerService: TimerService) {
        self.locationService = locationService
        self.motionService = motionService
        self.timerService = timerService
        completedSessions = SessionHistoryStore.load()

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

    var strokeRate: Int? {
        motionService.strokeRate
    }

    var gpsStatus: GPSStatus {
        locationService.gpsStatus
    }

    func startSession() {
        activeSession = RowSession(startedAt: Date())
        locationService.reset()
        motionService.reset()
        locationService.startTracking()
        motionService.startTracking()
        timerService.reset()
        timerService.start()
        state = .active
    }

    func pauseSession() {
        switch state {
        case .active:
            timerService.pause()
            locationService.pauseTracking()
            motionService.pauseTracking()
            state = .paused
        case .paused:
            locationService.startTracking()
            motionService.startTracking()
            timerService.start()
            state = .active
        case .idle:
            break
        }
    }

    func stopSession() {
        guard state == .paused else { return }

        activeSession.endedAt = Date()
        activeSession.elapsedTime = elapsedTime
        activeSession.distanceMeters = distanceMeters
        activeSession.maximumSpeedMetersPerSecond = max(
            activeSession.maximumSpeedMetersPerSecond,
            currentSpeedMetersPerSecond
        )
        activeSession.gpsPoints = locationService.points
        completedSessions.insert(activeSession, at: 0)
        SessionHistoryStore.save(completedSessions)

        timerService.reset()
        locationService.stopTracking()
        motionService.stopTracking()
        state = .idle
    }

    private func bindServices() {
        timerService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        locationService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        motionService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

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
