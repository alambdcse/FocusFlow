import Foundation

protocol CloudSyncing {
    func saveHabits(_ habits: [Habit])
    func loadHabits() -> [Habit]?
}

#if !os(Linux)
final class CloudSyncManager: CloudSyncing {
    private let keyValueStore = NSUbiquitousKeyValueStore.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let key = "focusflow.habits"

    func saveHabits(_ habits: [Habit]) {
        guard let data = try? encoder.encode(habits) else { return }
        keyValueStore.set(data, forKey: key)
        keyValueStore.synchronize()
    }

    func loadHabits() -> [Habit]? {
        guard let data = keyValueStore.data(forKey: key) else { return nil }
        return try? decoder.decode([Habit].self, from: data)
    }
}
#else
final class CloudSyncManager: CloudSyncing {
    func saveHabits(_ habits: [Habit]) {}
    func loadHabits() -> [Habit]? { nil }
}
#endif
