import Foundation

struct RowSession: Identifiable, Hashable, Codable {
    let id: UUID
    var startedAt: Date
    var endedAt: Date?
    var elapsedTime: TimeInterval
    var distanceMeters: Double
    var maximumSpeedMetersPerSecond: Double
    var gpsPoints: [GPSPoint]

    init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        elapsedTime: TimeInterval = 0,
        distanceMeters: Double = 0,
        maximumSpeedMetersPerSecond: Double = 0,
        gpsPoints: [GPSPoint] = []
    ) {
        self.id = id
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.elapsedTime = elapsedTime
        self.distanceMeters = distanceMeters
        self.maximumSpeedMetersPerSecond = maximumSpeedMetersPerSecond
        self.gpsPoints = gpsPoints
    }
}
