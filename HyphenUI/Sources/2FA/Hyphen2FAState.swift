@_spi(HyphenInternal) import HyphenCore
import SwiftUI
import HyphenNetwork

class Hyphen2FAState: ObservableObject {
    @Published var twoFactorAuth: Hyphen2FAStatus? = nil

    @Published var remainingTimeSeconds = 3 * 60
    
    @Published var isProcessing = false

    var remainingTimeText: String {
        if remainingTimeSeconds == 0 {
            return ""
        }
        
        return " (\(remainingTimeSeconds / 60):\(String(format: "%02d", remainingTimeSeconds % 60)))"
    }

    init() {
        startCountdownTimer()
    }
    
    func reject2FA() {
        guard let twoFactorAuth = self.twoFactorAuth else {
            HyphenLogger.shared.logger.critical("HyphenUI SDK internal error. UI state 'twoFactorAuth' is nil.")
            return
        }
        
        isProcessing = true
        
        Task {
            try await HyphenNetworking.shared.deny2FA(id: twoFactorAuth.id)
            await UIApplication.shared.hyphensdk_currentKeyWindowPresentedController?.dismiss(animated: true)
        }
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
