import Foundation

enum SplitCalculator {
    static func splitSeconds(for speedMetersPerSecond: Double) -> TimeInterval? {
        guard speedMetersPerSecond > 0 else { return nil }

        // Rowing split is the time required to cover 500 meters at the current speed.
        return 500 / speedMetersPerSecond
    }

    static func averageSplitSeconds(distanceMeters: Double, elapsedTime: TimeInterval) -> TimeInterval? {
        guard distanceMeters > 0, elapsedTime > 0 else { return nil }

        let averageSpeed = distanceMeters / elapsedTime
        return splitSeconds(for: averageSpeed)
    }
}
