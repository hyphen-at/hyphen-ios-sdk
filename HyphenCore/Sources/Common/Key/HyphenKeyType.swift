import Foundation

public enum HyphenKeyType: String, Codable, Sendable {
    case userKey = "user-key"
    case recoverKey = "recover-key"
    case serverKey = "server-key"
}
