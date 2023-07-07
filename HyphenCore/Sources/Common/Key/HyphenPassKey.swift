import Foundation

public struct HyphenPassKey: Codable, Equatable, Sendable {
    public let platform: HyphenPassKeyPlatform

    public enum HyphenPassKeyPlatform: String, Codable, Sendable {
        case android
        case ios
    }
}
