import CryptoKit
import Flow
import Foundation
import HyphenNetwork
@_spi(HyphenInternal) import HyphenCore

public final class HyphenServerKeySigner: FlowSigner {
    private let _address: Flow.Address

    public init(address: Flow.Address) {
        _address = address
    }

    public var address: Flow.Address {
        _address
    }

    public var keyIndex: Int = 0

    public func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        HyphenLogger.shared.logger.info("HyphenServerKey signing request")

        let signResult = try await HyphenNetworking.shared.signTransactionWithServerKey(message: signableData.hexValue)
        return Data(hexString: signResult.signature.signature)!
    }
}
