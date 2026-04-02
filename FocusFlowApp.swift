import SwiftUI

@main
struct FocusFlowApp: App {
    @StateObject private var habitStore = HabitStore()
    @StateObject private var subscriptionManager = SubscriptionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(habitStore)
                .environmentObject(subscriptionManager)
        }
    }
}
