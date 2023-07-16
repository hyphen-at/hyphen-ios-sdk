import Foundation

public struct HyphenTransaction: Codable, Equatable, Sendable, Hashable {
    public let id: String
    public let chainName: String
    public let refUrl: String

    private enum CodingKeys: String, CodingKey {
        case id
        case chainName
        case refUrl
    }

    public init(id: String, chainName: String, refUrl: String) {
        self.id = id
        self.chainName = chainName
        self.refUrl = refUrl
    }
}
