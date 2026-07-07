import SwiftUI

@main
struct LiveRowApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var motionService = MotionService()
    @StateObject private var timerService = TimerService()
    @StateObject private var sessionManager: SessionManager

    init() {
        let locationService = LocationService()
        let motionService = MotionService()
        let timerService = TimerService()

        _locationService = StateObject(wrappedValue: locationService)
        _motionService = StateObject(wrappedValue: motionService)
        _timerService = StateObject(wrappedValue: timerService)
        _sessionManager = StateObject(
            wrappedValue: SessionManager(
                locationService: locationService,
                motionService: motionService,
                timerService: timerService
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(sessionManager)
                .preferredColorScheme(.dark)
        }
    }
}
