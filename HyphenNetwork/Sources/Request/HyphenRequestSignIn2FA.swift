import Foundation
import HyphenCore

public struct HyphenRequestSignIn2FA: Codable, Sendable, Hashable {
    public let request: HyphenRequestSignIn2FA.Request
    public let userKey: HyphenUserKey

    public init(request: HyphenRequestSignIn2FA.Request, userKey: HyphenUserKey) {
        self.request = request
        self.userKey = userKey
    }

    public struct Request: Codable, Sendable, Hashable, Equatable {
        public let method: String
        public let token: String
        public let chainName: String

        public init(method: String, token: String, chainName: String) {
            self.method = method
            self.token = token
            self.chainName = chainName
        }

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
