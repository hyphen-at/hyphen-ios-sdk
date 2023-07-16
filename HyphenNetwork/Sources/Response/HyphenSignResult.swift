import Foundation
import HyphenCore

public struct HyphenSignResult: Codable, Sendable, Equatable {
    public let signature: HyphenSignature

    private enum CodingKeys: String, CodingKey {
        case signature
    }

    public init(signature: HyphenSignature) {
        self.signature = signature
    }
}

public struct HyphenSignature: Codable, Sendable, Equatable {
    public let addr: String
    public let keyId: Int
    public let signature: String

    private enum CodingKeys: String, CodingKey {
        case addr
        case keyId
        case signature
    }
}
