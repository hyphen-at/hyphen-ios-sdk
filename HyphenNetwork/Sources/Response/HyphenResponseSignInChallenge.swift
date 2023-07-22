import Foundation
import HyphenCore

public struct HyphenResponseSignInChallenge: Codable, Sendable, Equatable {
    public let challengeData: String
    public let expiresAt: String

    private enum CodingKeys: String, CodingKey {
        case challengeData
        case expiresAt
    }

    public init(challengeData: String, expiresAt: String) {
        self.challengeData = challengeData
        self.expiresAt = expiresAt
    }
}
