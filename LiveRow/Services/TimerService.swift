import Foundation

@MainActor
final class TimerService: ObservableObject {
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var isRunning = false

    private var startedAt: Date?
    private var accumulatedTime: TimeInterval = 0
    private var timerTask: Task<Void, Never>?
    private let tickNanoseconds: UInt64 = 1_000_000_000

    func start() {
        guard !isRunning else { return }
        startedAt = Date()
        isRunning = true
        updateElapsedTime()
        startTicking()
    }

    func pause() {
        guard isRunning else { return }
        if let startedAt {
            accumulatedTime += Date().timeIntervalSince(startedAt)
        }
        startedAt = nil
        elapsedTime = accumulatedTime
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
    }

    func reset() {
        timerTask?.cancel()
        timerTask = nil
        startedAt = nil
        accumulatedTime = 0
        elapsedTime = 0
        isRunning = false
    }

    private func startTicking() {
        timerTask?.cancel()
        timerTask = Task { [weak self] in
            while !Task.isCancelled {
                do {
                    try await Task.sleep(nanoseconds: self?.tickNanoseconds ?? 1_000_000_000)
                } catch {
                    break
                }
                self?.updateElapsedTime()
            }
        }
    }

    private func updateElapsedTime() {
        guard let startedAt else {
            elapsedTime = accumulatedTime
            return
        }
        elapsedTime = accumulatedTime + Date().timeIntervalSince(startedAt)
    }
}
