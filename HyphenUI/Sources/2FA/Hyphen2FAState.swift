import SwiftUI

@MainActor
class Hyphen2FAState: ObservableObject {
    @Published var appName: String = ""
    @Published var requestDeviceName: String = ""
    @Published var requestEmail: String = ""
    @Published var near: String = ""

    @Published var remainingTimeText: String = " (3:00)"
}
