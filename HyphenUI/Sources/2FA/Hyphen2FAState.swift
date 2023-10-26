@_spi(HyphenInternal) import HyphenCore
import HyphenFlow
import HyphenNetwork
import SwiftUI

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
        guard let twoFactorAuth else {
            HyphenLogger.shared.logger.critical("HyphenUI SDK internal error. UI state 'twoFactorAuth' is nil.")
            return
        }

        isProcessing = true

        Task {
            try await HyphenNetworking.shared.deny2FA(id: twoFactorAuth.id)
            await UIApplication.shared.hyphensdk_currentKeyWindowPresentedController?.dismiss(animated: true)
        }
    }

    func approve2FA() {
        isProcessing = true

        Task {
            HyphenLogger.shared.logger.info("Generate and signing 'source device add public key' transaction...")

            let cadenceScript = try! JSONDecoder().decode(HyphenFlowCadence.self, from: self.twoFactorAuth!.request.message.data(using: .utf8)!)

            let tx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithoutArguments(
                hyphenFlowCadence: HyphenFlowCadence(cadence: cadenceScript.cadence)
            )
            let txId = try await HyphenFlow.shared.sendSignedTransaction(tx)
            HyphenLogger.shared.logger.info("Transaction hash -> \(txId)")

            try await HyphenNetworking.shared.approve2FA(
                id: twoFactorAuth!.id,
                payload: HyphenRequest2FAApprove(txId: txId)
            )

            HyphenLogger.shared.logger.info("Approve 2FA done!")

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
