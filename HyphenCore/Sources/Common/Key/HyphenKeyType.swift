import Foundation

public enum HyphenKeyType: String, Hashable, Codable, Sendable {
    case userKey = "user-key"
    case recoverKey = "recover-key"
    case serverKey = "server-key"
}
