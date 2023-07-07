import Foundation

public struct HyphenKey: Codable, Equatable, Sendable {
    public let id: HyphenPublicKey
    public let type: HyphenKeyType
    public let name: String
    public let app: HyphenAppInformation
    public let userKey: HyphenUserKey?
    public let recoverKey: HyphenRecoverKey?
    public let lastUsedAt: String

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case app
        case userKey
        case recoverKey
        case lastUsedAt
    }

    public init(
        id: HyphenPublicKey,
        type: HyphenKeyType,
        name: String,
        app: HyphenAppInformation,
        userKey: HyphenUserKey?,
        recoverKey: HyphenRecoverKey?,
        lastUsedAt: String
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.app = app
        self.userKey = userKey
        self.recoverKey = recoverKey
        self.lastUsedAt = lastUsedAt
    }
}
