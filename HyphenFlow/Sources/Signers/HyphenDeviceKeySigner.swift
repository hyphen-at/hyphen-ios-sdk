import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork

public final class HyphenDeviceKeySigner: FlowSigner {
    private let _address: Flow.Address
    private let _keyIndex: Int

    public init(address: Flow.Address, keyIndex: Int) {
        _address = address
        _keyIndex = keyIndex
    }

    public var address: Flow.Address {
        _address
    }

    public var keyIndex: Int {
        _keyIndex
    }

    public func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        HyphenLogger.shared.logger.info("HyphenDeviceKey signing request")
        return HyphenCryptography.signData(signableData)!
    }
}
