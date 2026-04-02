import Foundation
import SwiftUI

final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit] = []

    private let notificationManager: NotificationManaging
    private let cloudSyncManager: CloudSyncing

    private let localKey = "focusflow.localHabits"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        notificationManager: NotificationManaging = NotificationManager(),
        cloudSyncManager: CloudSyncing = CloudSyncManager()
    ) {
        self.notificationManager = notificationManager
        self.cloudSyncManager = cloudSyncManager
        self.notificationManager.requestAuthorizationIfNeeded()
        loadInitialHabits()
    }

    func addHabit(named name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        habits.append(Habit(name: trimmed))
        persist()
    }

    func toggleHabit(_ habit: Habit, for date: Date = Date()) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].toggleCompletion(for: date)
        persist()
    }

    func toggleReminder(for habit: Habit, enabled: Bool) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].reminderEnabled = enabled

        if enabled {
            notificationManager.scheduleReminder(for: habits[index])
        } else {
            notificationManager.removeReminder(for: habits[index])
        }

        persist()
    }

    var completedTodayCount: Int {
        habits.filter { $0.isCompleted(on: Date()) }.count
    }

    var weeklyCompletions: [Int] {
        (0..<7).map { offset in
            let day = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) ?? Date()
            return habits.reduce(0) { partial, habit in
                partial + (habit.isCompleted(on: day) ? 1 : 0)
            }
        }.reversed()
    }

    private func loadInitialHabits() {
        if let cloud = cloudSyncManager.loadHabits(), !cloud.isEmpty {
            habits = cloud
            return
        }

        if let local = loadLocalHabits(), !local.isEmpty {
            habits = local
            return
        }

        habits = [
            Habit(name: "Drink Water"),
            Habit(name: "Read 10 Minutes")
        ]
        persist()
    }

    private func loadLocalHabits() -> [Habit]? {
        guard let data = UserDefaults.standard.data(forKey: localKey) else { return nil }
        return try? decoder.decode([Habit].self, from: data)
    }

    private func persist() {
        if let data = try? encoder.encode(habits) {
            UserDefaults.standard.set(data, forKey: localKey)
        }

        cloudSyncManager.saveHabits(habits)
    }
}
