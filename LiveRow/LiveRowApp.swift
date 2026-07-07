import SwiftUI

@main
struct LiveRowApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var timerService = TimerService()
    @StateObject private var sessionManager: SessionManager

    init() {
        let locationService = LocationService()
        let timerService = TimerService()

        _locationService = StateObject(wrappedValue: locationService)
        _timerService = StateObject(wrappedValue: timerService)
        _sessionManager = StateObject(
            wrappedValue: SessionManager(
                locationService: locationService,
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
