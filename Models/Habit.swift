import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var completedDates: Set<Date>
    var reminderEnabled: Bool
    var reminderHour: Int
    var reminderMinute: Int

    init(
        id: UUID = UUID(),
        name: String,
        completedDates: Set<Date> = [],
        reminderEnabled: Bool = false,
        reminderHour: Int = 20,
        reminderMinute: Int = 0
    ) {
        self.id = id
        self.name = name
        self.completedDates = completedDates
        self.reminderEnabled = reminderEnabled
        self.reminderHour = reminderHour
        self.reminderMinute = reminderMinute
    }

    func isCompleted(on date: Date, calendar: Calendar = .current) -> Bool {
        completedDates.contains { completedDate in
            calendar.isDate(completedDate, inSameDayAs: date)
        }
    }

    mutating func toggleCompletion(for date: Date, calendar: Calendar = .current) {
        if let existing = completedDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            completedDates.remove(existing)
        } else {
            completedDates.insert(date)
        }
    }

    func currentStreak(calendar: Calendar = .current) -> Int {
        var streak = 0
        var dayOffset = 0

        while true {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else {
                break
            }

            if isCompleted(on: date, calendar: calendar) {
                streak += 1
                dayOffset += 1
            } else {
                break
            }
        }

        return streak
    }

    func weeklyCompletionCount(calendar: Calendar = .current, today: Date = Date()) -> Int {
        let week = (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: today)
        }

        return week.reduce(0) { count, date in
            count + (isCompleted(on: date, calendar: calendar) ? 1 : 0)
        }
    }
}
