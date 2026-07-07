import CoreMotion
import Foundation

@MainActor
final class MotionService: ObservableObject {
    @Published private(set) var strokeRate: Int?

    private let motionManager = CMMotionManager()
    private var lastPeakTime: TimeInterval?
    private var strokeIntervals: [TimeInterval] = []
    private var isAboveStrokeThreshold = false

    private let updateInterval: TimeInterval = 0.05
    private let strokeThreshold = 0.18
    private let minimumStrokeInterval: TimeInterval = 0.8
    private let maximumStrokeInterval: TimeInterval = 3.5
    private let staleStrokeInterval: TimeInterval = 6

    func startTracking() {
        guard motionManager.isDeviceMotionAvailable else {
            strokeRate = nil
            return
        }

        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion else { return }

            let acceleration = motion.userAcceleration
            let magnitude = sqrt(
                acceleration.x * acceleration.x +
                acceleration.y * acceleration.y +
                acceleration.z * acceleration.z
            )

            Task { @MainActor [weak self] in
                self?.processAccelerationMagnitude(magnitude)
            }
        }
    }

    func pauseTracking() {
        motionManager.stopDeviceMotionUpdates()
    }

    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
        reset()
    }

    func reset() {
        strokeRate = nil
        lastPeakTime = nil
        strokeIntervals.removeAll()
        isAboveStrokeThreshold = false
    }

    private func processAccelerationMagnitude(_ magnitude: Double) {
        let now = Date().timeIntervalSinceReferenceDate

        if let lastPeakTime, now - lastPeakTime > staleStrokeInterval {
            strokeRate = nil
            strokeIntervals.removeAll()
            self.lastPeakTime = nil
        }

        guard magnitude >= strokeThreshold else {
            isAboveStrokeThreshold = false
            return
        }

        guard !isAboveStrokeThreshold else { return }
        isAboveStrokeThreshold = true

        guard let lastPeakTime else {
            self.lastPeakTime = now
            return
        }

        let interval = now - lastPeakTime
        self.lastPeakTime = now

        guard interval >= minimumStrokeInterval, interval <= maximumStrokeInterval else {
            return
        }

        strokeIntervals.append(interval)
        if strokeIntervals.count > 4 {
            strokeIntervals.removeFirst()
        }

        let averageInterval = strokeIntervals.reduce(0, +) / Double(strokeIntervals.count)
        strokeRate = Int((60 / averageInterval).rounded())
    }
}
