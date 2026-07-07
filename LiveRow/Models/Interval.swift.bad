import Foundation

struct Interval: Identifiable, Hashable {
    let id: UUID
    var name: String
    var targetDistanceMeters: Double?
    var targetDurationSeconds: TimeInterval?
    var restDurationSeconds: TimeInterval?

    init(
        id: UUID = UUID(),
        name: String,
        targetDistanceMeters: Double? = nil,
        targetDurationSeconds: TimeInterval? = nil,
        restDurationSeconds: TimeInterval? = nil
    ) {
        self.id = id
        self.name = name
        self.targetDistanceMeters = targetDistanceMeters
        self.targetDurationSeconds = targetDurationSeconds
        self.restDurationSeconds = restDurationSeconds
    }
}
