import Flow
import Foundation
import HyphenCore
import HyphenNetwork

public final class HyphenFlow: NSObject {
    public static let shared: HyphenFlow = .init()

    override private init() {}

    public func makeSignedTransactionPayloadWithoutArguments(hyphenFlowCadence: HyphenFlowCadence) async throws -> Flow.Transaction {
        let hyphenAccount = try await HyphenNetworking.shared.getMyAccount()
        let flowAddress = Flow.Address(hex: hyphenAccount.addresses.first!.address)
        let keys = try await HyphenNetworking.shared.getKeys()
        let deviceKeyIndex = keys.first { $0.publicKey == HyphenCryptography.getPublicKeyHex() }!.keyIndex

        let deviceKeySigner = HyphenDeviceKeySigner(address: flowAddress, keyIndex: deviceKeyIndex)
        let serverKeySigner = HyphenServerKeySigner(address: flowAddress)
        let payMasterKeySigner = HyphenPayMasterKeySigner()

        let signers: [FlowSigner] = [serverKeySigner, deviceKeySigner, payMasterKeySigner]

        var unsignedTx = try! await flow.buildTransaction {
            cadence {
                hyphenFlowCadence.cadence
            }

            proposer {
                Flow.TransactionProposalKey(address: deviceKeySigner.address, keyIndex: deviceKeySigner.keyIndex)
            }

            payer {
                payMasterKeySigner.address
            }

            authorizers {
                deviceKeySigner.address
            }
        }

        let signedTx = try await unsignedTx.sign(signers: signers)
        return signedTx
    }

    public func sendSignedTransaction(_ transaction: Flow.Transaction) async throws -> String {
        let txWait = try await flow.sendTransaction(transaction: transaction)
        return "\(txWait)"
    }

    public func waitTransactionSealed(txId: String) async throws {
        let tx = Flow.ID(hex: txId)
        _ = try await tx.onceSealed()
    }
}
