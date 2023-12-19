@_spi(HyphenInternal) import HyphenCore
import HyphenFlow
import HyphenNetwork
import SwiftUI

class HyphenKeyListState: ObservableObject {
    @Published var keys: [HyphenKey] = []

    @Published var isLoading: Bool = true

    @Published var pendingRevokeKey: HyphenKey? = nil

    private var processRevokeKey: HyphenKey? = nil

    @Published var isShowRevokeKeyConfirmSheet: Bool = false

    init() {
        loadKeys()
    }

    private func loadKeys() {
        isLoading = true

        Task {
            let fetchKeysResult = try await HyphenNetworking.shared.getKeys()

            DispatchQueue.main.async {
                self.keys = fetchKeysResult
                self.isLoading = false
            }
        }
    }

    func pendingRevokeKey(_ key: HyphenKey?) {
        pendingRevokeKey = key
        isShowRevokeKeyConfirmSheet = key != nil
    }

    func revokeKey() {
        processRevokeKey = pendingRevokeKey
        pendingRevokeKey = nil
        isShowRevokeKeyConfirmSheet = false

        isLoading = true

        Task {
            do {
                let tx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithoutArguments(
                    hyphenFlowCadence: HyphenFlowCadence(cadence: """
                    transaction() {
                        prepare(signer: AuthAccount) {
                            signer.keys.revoke(keyIndex: \(processRevokeKey?.keyIndex ?? -1))
                        }
                    }
                    """)
                )
                let txId = try await HyphenFlow.shared.sendSignedTransaction(tx)
                HyphenLogger.shared.logger.info("[RevokeKeyTxHash] \(txId)")

                try await HyphenNetworking.shared.deleteKey(processRevokeKey?.publicKey ?? "")

                DispatchQueue.main.async {
                    self.processRevokeKey = nil
                    self.isLoading = false

                    self.loadKeys()
                }
            } catch {
                print(error)
            }
        }
    }
}
