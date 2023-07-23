import HyphenCore
import SwiftUI

class Hyphen2FAState: ObservableObject {
    @Published var twoFactorAuth: Hyphen2FAStatus? = nil

    @Published private var remainingTimeSeconds = 3 * 60

    var remainingTimeText: String {
        " (\(remainingTimeSeconds / 60):\(String(format: "%02d", remainingTimeSeconds % 60)))"
    }

    init() {
        startCountdownTimer()
    }

    private func startCountdownTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.remainingTimeSeconds == 0 {
                timer.invalidate()
                return
            }

            self.remainingTimeSeconds -= 1
        }
    }
}
