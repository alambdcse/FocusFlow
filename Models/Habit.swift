import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var completedDates: Set<Date>

    init(id: UUID = UUID(), name: String, completedDates: Set<Date> = []) {
        self.id = id
        self.name = name
        self.completedDates = completedDates
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
}
