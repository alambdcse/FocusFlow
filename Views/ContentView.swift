import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: HabitStore
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var newHabitName = ""

    var body: some View {
        TabView {
            habitsTab
                .tabItem {
                    Label("Habits", systemImage: "checkmark.circle")
                }

            WeeklyInsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }

            premiumTab
                .tabItem {
                    Label("Premium", systemImage: "star")
                }
        }
    }

    private var habitsTab: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Today's progress: \(store.completedTodayCount)/\(store.habits.count)")
                    .font(.headline)

                HStack {
                    TextField("New habit", text: $newHabitName)
                        .textFieldStyle(.roundedBorder)

                    Button("Add") {
                        store.addHabit(named: newHabitName)
                        newHabitName = ""
                    }
                }

                List {
                    ForEach(store.habits) { habit in
                        HabitRow(
                            habit: habit,
                            onToggle: { store.toggleHabit(habit) },
                            onReminderToggle: { enabled in store.toggleReminder(for: habit, enabled: enabled) }
                        )
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("FocusFlow")
        }
    }

    private var premiumTab: some View {
        VStack(spacing: 16) {
            Text("Premium Tier")
                .font(.title2.bold())

            Text(subscriptionManager.isPremium ? "Premium is Active" : "Upgrade to unlock advanced analytics and widgets")
                .multilineTextAlignment(.center)

            Button(subscriptionManager.isPremium ? "Subscribed" : "Upgrade") {
                subscriptionManager.upgradeToPremium()
            }
            .buttonStyle(.borderedProminent)
            .disabled(subscriptionManager.isPremium)
        }
        .padding()
    }
}

private struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void
    let onReminderToggle: (Bool) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.body)
                    Text("Streak: \(habit.currentStreak()) days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: onToggle) {
                    Image(systemName: habit.isCompleted(on: Date()) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(habit.isCompleted(on: Date()) ? .green : .gray)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }

            Toggle("Reminder", isOn: Binding(
                get: { habit.reminderEnabled },
                set: { onReminderToggle($0) }
            ))
            .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .environmentObject(HabitStore())
        .environmentObject(SubscriptionManager())
}
