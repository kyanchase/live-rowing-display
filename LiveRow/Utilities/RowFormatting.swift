import Foundation

enum RowFormatting {
    static func time(_ interval: TimeInterval) -> String {
        let totalSeconds = max(Int(interval), 0)
        let hours = totalSeconds / 3_600
        let minutes = (totalSeconds % 3_600) / 60
        let seconds = totalSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }

        return String(format: "%02d:%02d", minutes, seconds)
    }

    static func distanceMeters(_ meters: Double) -> String {
        String(format: "%.0f", max(meters, 0))
    }

    static func speed(_ metersPerSecond: Double) -> String {
        String(format: "%.1f", max(metersPerSecond, 0))
    }

    static func split(_ splitSeconds: TimeInterval?) -> String {
        guard let splitSeconds, splitSeconds.isFinite, splitSeconds > 0 else {
            return "--:--"
        }

        let roundedSeconds = Int(splitSeconds.rounded())
        let minutes = roundedSeconds / 60
        let seconds = roundedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
