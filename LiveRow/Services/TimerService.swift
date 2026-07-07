import Foundation

@MainActor
final class TimerService: ObservableObject {
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var isRunning = false

    private var startedAt: Date?
    private var accumulatedTime: TimeInterval = 0
    private var timerTask: Task<Void, Never>?

    func start() {
        guard !isRunning else { return }
        startedAt = Date()
        isRunning = true
        startTicking()
    }

    func pause() {
        guard isRunning else { return }
        if let startedAt {
            accumulatedTime += Date().timeIntervalSince(startedAt)
        }
        startedAt = nil
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
                self?.updateElapsedTime()
                try? await Task.sleep(for: .seconds(1))
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
