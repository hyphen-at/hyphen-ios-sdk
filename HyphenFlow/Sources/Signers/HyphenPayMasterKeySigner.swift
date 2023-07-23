import CryptoKit
import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork

final class HyphenPayMasterKeySigner: FlowSigner {
    var address: Flow.Address {
        Flow.Address(hex: "0xe22cea2c515f26e6")
    }

    private var _keyIndex: Int = 0
    var keyIndex: Int {
        _keyIndex
    }

    func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        HyphenLogger.shared.logger.info("HyphenPayMasterKey signing request")

        let signResult = try await HyphenNetworking.shared.signTransactionWithPayMasterKey(message: signableData.hexValue)
        return Data(hexString: signResult.signature.signature)!
    }
}
