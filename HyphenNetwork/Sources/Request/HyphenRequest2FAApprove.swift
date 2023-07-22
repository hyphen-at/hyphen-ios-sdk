import Foundation

public struct HyphenRequest2FAApprove: Codable {
    public let signature: String

    public init(signature: String) {
        self.signature = signature
    }

    enum CodingKeys: String, CodingKey {
        case signature
    }
}
