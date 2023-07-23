import Foundation

public struct HyphenRecoverKey: Codable, Hashable, Equatable, Sendable {
    public let type: RecoveryType
    public let cloudKey: CloudKey?

    public enum RecoveryType: String, Codable, Sendable {
        case type
        case cloudKey
    }

    public struct CloudKey: Codable, Hashable, Equatable, Sendable {
        public let accountName: String
    }
}
