import Foundation

@MainActor
struct ActiveSessionViewModel {
    private let sessionManager: SessionManager

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    var elapsedTime: String {
        RowFormatting.time(sessionManager.elapsedTime)
    }

    var distance: String {
        RowFormatting.distanceMeters(sessionManager.distanceMeters)
    }

    var currentSpeed: String {
        RowFormatting.speed(sessionManager.currentSpeedMetersPerSecond)
    }

    var currentSplit: String {
        RowFormatting.split(sessionManager.currentSplitSeconds)
    }

    var averageSplit: String {
        RowFormatting.split(sessionManager.averageSplitSeconds)
    }

    var strokeRate: String {
        RowFormatting.strokeRate(sessionManager.strokeRate)
    }

    var gpsStatusText: String {
        sessionManager.gpsStatus.displayName
    }

    var pauseButtonTitle: String {
        sessionManager.state == .paused ? "Resume" : "Pause"
    }
}
