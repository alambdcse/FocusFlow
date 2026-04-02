import SwiftUI
import WidgetKit

struct FocusFlowEntry: TimelineEntry {
    let date: Date
    let completed: Int
    let total: Int
}

struct FocusFlowProvider: TimelineProvider {
    func placeholder(in context: Context) -> FocusFlowEntry {
        FocusFlowEntry(date: Date(), completed: 2, total: 5)
    }

    func getSnapshot(in context: Context, completion: @escaping (FocusFlowEntry) -> Void) {
        completion(FocusFlowEntry(date: Date(), completed: 2, total: 5))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FocusFlowEntry>) -> Void) {
        let entry = FocusFlowEntry(date: Date(), completed: 2, total: 5)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}

struct FocusFlowWidgetEntryView: View {
    var entry: FocusFlowProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("FocusFlow")
                .font(.headline)
            Text("Today: \(entry.completed)/\(entry.total)")
                .font(.title3.bold())
        }
        .padding()
    }
}

struct FocusFlowWidget: Widget {
    let kind: String = "FocusFlowWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FocusFlowProvider()) { entry in
            FocusFlowWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Habit Progress")
        .description("See your daily FocusFlow progress.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    FocusFlowWidget()
} timeline: {
    FocusFlowEntry(date: Date(), completed: 3, total: 5)
}
