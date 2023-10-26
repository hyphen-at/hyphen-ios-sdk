import Flow
import Foundation
import HyphenCore
import HyphenNetwork

public final class HyphenFlow: NSObject {
    public static let shared: HyphenFlow = .init()

    override private init() {}

    public func makeSignedTransactionPayloadWithoutArguments(hyphenFlowCadence: HyphenFlowCadence) async throws -> Flow.Transaction {
        configureFlow()

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

    public func makeSignedTransactionPayloadWithArguments(hyphenFlowCadence: HyphenFlowCadence, args: [Flow.Cadence.FValue]) async throws -> Flow.Transaction {
        configureFlow()

        print(URL(string: HyphenNetworking.shared.baseUrl)!)

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

            arguments {
                args
            }

            authorizers {
                deviceKeySigner.address
            }
        }

        let signedTx = try await unsignedTx.sign(signers: signers)
        return signedTx
    }

    public func sendSignedTransaction(_ transaction: Flow.Transaction) async throws -> String {
        configureFlow()

        let txWait = try await flow.sendTransaction(transaction: transaction)
        return "\(txWait)"
    }

    public func waitTransactionSealed(txId: String) async throws {
        configureFlow()

        let tx = Flow.ID(hex: "0x\(txId)")
        let transactionResult = try await flow.getTransactionResultById(id: tx)

        if transactionResult.status != .sealed {
            _ = try await tx.onceSealed()
        }
    }

    private func configureFlow() {
        if Hyphen.shared.network == .testnet {
            flow.configure(chainID: .testnet)
        } else {
            flow.configure(chainID: .mainnet)
        }
    }
}
