import Foundation

final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit] = [
        Habit(name: "Drink Water"),
        Habit(name: "Read 10 Minutes")
    ]

    func addHabit(named name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        habits.append(Habit(name: trimmed))
    }

    func toggleHabit(_ habit: Habit, for date: Date = Date()) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index].toggleCompletion(for: date)
    }

    var completedTodayCount: Int {
        habits.filter { $0.isCompleted(on: Date()) }.count
    }
}
