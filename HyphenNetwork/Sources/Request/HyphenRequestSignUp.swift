import Foundation
import HyphenCore

public struct HyphenRequestSignUp: Codable, Sendable, Hashable {
    public let method: String
    public let token: String
//    public let chainName: String
    public let userKey: HyphenUserKey

    public init(method: String, token: String, chainName _: String, userKey: HyphenUserKey) {
        self.method = method
        self.token = token
//        self.chainName = chainName
        self.userKey = userKey
    }

    enum CodingKeys: String, CodingKey {
        case method
        case token
//        case chainName
        case userKey
    }
}
