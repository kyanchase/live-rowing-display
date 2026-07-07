import Foundation

struct Interval: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var targetDistanceMeters: Double?
    var targetDuration: TimeInterval?
    var restDuration: TimeInterval

    init(
        id: UUID = UUID(),
        name: String,
        targetDistanceMeters: Double? = nil,
        targetDuration: TimeInterval? = nil,
        restDuration: TimeInterval = 0
    ) {
        self.id = id
        self.name = name
        self.targetDistanceMeters = targetDistanceMeters
        self.targetDuration = targetDuration
        self.restDuration = restDuration
    }
}
