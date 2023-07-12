import Foundation

public struct HyphenRequestSignIn: Codable, Sendable, Hashable {
    public let method: String
    public let token: String
    public let chainName: String

    enum CodingKeys: String, CodingKey {
        case method
        case token
        case chainName
    }
}
