import CryptoKit
import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork

public final class HyphenPayMasterKeySigner: FlowSigner {
    public var address: Flow.Address {
        if Hyphen.shared.network == .testnet {
            Flow.Address(hex: "0xe22cea2c515f26e6")
        } else {
            Flow.Address(hex: "0xd998bea00bb8d39c")
        }
    }

    private var _keyIndex: Int = 0
    public var keyIndex: Int {
        _keyIndex
    }

    public func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        HyphenLogger.shared.logger.info("HyphenPayMasterKey signing request")

        let signResult = try await HyphenNetworking.shared.signTransactionWithPayMasterKey(message: signableData.hexValue)
        return Data(hexString: signResult.signature.signature)!
    }
}
