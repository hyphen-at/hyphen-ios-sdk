import Foundation

public struct HyphenRecoverKey: Codable, Equatable, Sendable {
    public let type: RecoveryType
    public let cloudKey: CloudKey?

    public enum RecoveryType: String, Codable, Sendable {
        case icloud
        case google
        case email
        case sms
        case custom
    }

    public struct CloudKey: Codable, Equatable, Sendable {
        public let accountName: String
    }
}
