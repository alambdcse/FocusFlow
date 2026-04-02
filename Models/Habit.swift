import Foundation

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var completedDates: Set<Date>
    var completionEvents: [Date]
    var reminderEnabled: Bool
    var reminderHour: Int
    var reminderMinute: Int

    init(
        id: UUID = UUID(),
        name: String,
        completedDates: Set<Date> = [],
        completionEvents: [Date] = [],
        reminderEnabled: Bool = false,
        reminderHour: Int = 20,
        reminderMinute: Int = 0
    ) {
        self.id = id
        self.name = name
        self.completedDates = completedDates
        self.completionEvents = completionEvents
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
            completionEvents.removeAll { calendar.isDate($0, inSameDayAs: date) }
        } else {
            completedDates.insert(date)
            completionEvents.append(date)
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

    func suggestedReminderTime(calendar: Calendar = .current) -> DateComponents? {
        guard !completionEvents.isEmpty else { return nil }

        let minutes = completionEvents.compactMap { event -> Int? in
            let components = calendar.dateComponents([.hour, .minute], from: event)
            guard let hour = components.hour, let minute = components.minute else { return nil }
            return hour * 60 + minute
        }.sorted()

        guard !minutes.isEmpty else { return nil }
        let median = minutes[minutes.count / 2]

        var components = DateComponents()
        components.hour = median / 60
        components.minute = median % 60
        return components
    }
}
ios/FocusFlow/Services/CloudSyncing.swift
