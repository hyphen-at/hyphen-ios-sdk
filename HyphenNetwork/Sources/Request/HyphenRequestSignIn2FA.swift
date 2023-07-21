import Foundation
import HyphenCore

public struct HyphenRequestSignIn2FA: Codable, Sendable, Hashable {
    public let request: HyphenRequestSignIn2FA.Request
    public let userKey: HyphenUserKey

    public struct Request: Codable, Sendable, Hashable, Equatable {
        public let method: String
        public let token: String
        public let chainName: String

        enum CodingKeys: String, CodingKey {
            case method
            case token
            case chainName
        }
    }

    enum CodingKeys: String, CodingKey {
        case request
        case userKey
    }
}
