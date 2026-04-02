import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: HabitStore
    @State private var newHabitName = ""

    var body: some View {
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
                        HabitRow(habit: habit) {
                            store.toggleHabit(habit)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .padding()
            .navigationTitle("FocusFlow")
        }
    }
}

private struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void

    var body: some View {
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
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .environmentObject(HabitStore())
}
