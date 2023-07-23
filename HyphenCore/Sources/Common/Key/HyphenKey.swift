import Foundation

public struct HyphenKey: Codable, Hashable, Equatable, Sendable {
    public let publicKey: HyphenPublicKey
    public let type: HyphenKeyType
    public let name: String
    public let keyIndex: Int
    public let userKey: HyphenUserKey?
    public let recoverKey: HyphenRecoverKey?
    public let lastUsedAt: String

    private enum CodingKeys: String, CodingKey {
        case publicKey
        case type
        case name
        case keyIndex
        case userKey
        case recoverKey
        case lastUsedAt
    }

    public init(
        publicKey: HyphenPublicKey,
        type: HyphenKeyType,
        name: String,
        keyIndex: Int,
        userKey: HyphenUserKey?,
        recoverKey: HyphenRecoverKey?,
        lastUsedAt: String
    ) {
        self.publicKey = publicKey
        self.type = type
        self.name = name
        self.keyIndex = keyIndex
        self.userKey = userKey
        self.recoverKey = recoverKey
        self.lastUsedAt = lastUsedAt
    }
}
