import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork

final class HyphenDeviceKeySigner: FlowSigner {
    private let _address: Flow.Address
    private let _keyIndex: Int

    public init(address: Flow.Address, keyIndex: Int) {
        _address = address
        _keyIndex = keyIndex
    }

    var address: Flow.Address {
        _address
    }

    var keyIndex: Int {
        _keyIndex
    }

    func sign(transaction _: Flow.Transaction, signableData: Data) async throws -> Data {
        HyphenLogger.shared.logger.info("HyphenDeviceKey signing request")
        return HyphenCryptography.signData(signableData)!
    }
}
