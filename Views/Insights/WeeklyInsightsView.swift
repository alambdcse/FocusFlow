import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct WeeklyInsightsView: View {
    @EnvironmentObject private var store: HabitStore

    private var points: [InsightPoint] {
        let symbols = ["M", "T", "W", "T", "F", "S", "S"]
        return Array(zip(symbols, store.weeklyCompletions)).map { day, count in
            InsightPoint(day: day, completions: count)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Insights")
                .font(.title2.bold())

#if canImport(Charts)
            Chart(points) { point in
                BarMark(
                    x: .value("Day", point.day),
                    y: .value("Completed", point.completions)
                )
            }
            .frame(height: 220)
#else
            Text("Charts framework is unavailable on this platform.")
                .foregroundColor(.secondary)
#endif

            Text("Total completions this week: \(store.weeklyCompletions.reduce(0, +))")
                .font(.headline)

            Text("Coach tip")
                .font(.headline)
            Text(store.weeklyCoachTip)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}

private struct InsightPoint: Identifiable {
    let id = UUID()
    let day: String
    let completions: Int
}

#Preview {
    WeeklyInsightsView()
        .environmentObject(HabitStore())
}
