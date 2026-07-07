import Foundation

enum SessionHistoryStore {
    private static let storageKey = "LiveRow.completedSessions"
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    static func load() -> [RowSession] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        return (try? decoder.decode([RowSession].self, from: data)) ?? []
    }

    static func save(_ sessions: [RowSession]) {
        guard let data = try? encoder.encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
