import SwiftUI

@main
struct FocusFlowApp: App {
    @StateObject private var habitStore = HabitStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(habitStore)
        }
    }
}
