import Foundation

public struct HyphenRequestSignInChallenge: Codable, Sendable, Hashable, Equatable {
    public let challengeType: String
    public let request: HyphenRequestSignInChallenge.Request
    public let publicKey: String

    public init(challengeType: String, request: HyphenRequestSignInChallenge.Request, publicKey: String) {
        self.challengeType = challengeType
        self.request = request
        self.publicKey = publicKey
    }

    enum CodingKeys: String, CodingKey {
        case challengeType
        case request
        case publicKey
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
}
