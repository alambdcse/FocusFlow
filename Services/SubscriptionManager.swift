import Foundation
import SwiftUI

final class SubscriptionManager: ObservableObject {
    @Published private(set) var isPremium = false

    func upgradeToPremium() {
        // Placeholder for StoreKit purchase flow.
        isPremium = true
    }
}
