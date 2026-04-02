import Foundation

protocol NotificationManaging {
    func requestAuthorizationIfNeeded()
    func scheduleReminder(for habit: Habit)
    func removeReminder(for habit: Habit)
}

#if canImport(UserNotifications)
import UserNotifications

final class NotificationManager: NotificationManaging {
    private let center = UNUserNotificationCenter.current()

    func requestAuthorizationIfNeeded() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    func scheduleReminder(for habit: Habit) {
        guard habit.reminderEnabled else {
            removeReminder(for: habit)
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Habit Reminder"
        content.body = "Time to complete: \(habit.name)"
        content.sound = .default

        var components = DateComponents()
        components.hour = habit.reminderHour
        components.minute = habit.reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: habit.id.uuidString,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func removeReminder(for habit: Habit) {
        center.removePendingNotificationRequests(withIdentifiers: [habit.id.uuidString])
    }
}
#else
final class NotificationManager: NotificationManaging {
    func requestAuthorizationIfNeeded() {}
    func scheduleReminder(for habit: Habit) {}
    func removeReminder(for habit: Habit) {}
}
#endif
