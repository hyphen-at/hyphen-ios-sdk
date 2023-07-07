import Foundation

public struct HyphenAccount: Codable, Equatable, Sendable {
    public let id: String
    public let addresses: [HyphenAccountAddress]
    public let parent: [HyphenAccountAddress]
    public let createdAt: String

    private enum CodingKeys: String, CodingKey {
        case id
        case addresses
        case parent
        case createdAt
    }

    public init(
        id: String,
        addresses: [HyphenAccountAddress],
        parent: [HyphenAccountAddress],
        createdAt: String
    ) {
        self.id = id
        self.addresses = addresses
        self.parent = parent
        self.createdAt = createdAt
    }
}
