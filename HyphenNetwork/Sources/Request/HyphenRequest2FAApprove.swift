import Foundation

public struct HyphenRequest2FAApprove: Codable {
    public let txId: String

    public init(txId: String) {
        self.txId = txId
    }

    enum CodingKeys: String, CodingKey {
        case txId
    }
}
