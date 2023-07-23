import Foundation
import HyphenCore

public struct HyphenResponseSignIn2FA: Codable, Sendable, Equatable {
    public let twoFactorAuth: Hyphen2FAStatus
    public let ephemeralAccessToken: String

    enum CodingKeys: String, CodingKey {
        case twoFactorAuth
        case ephemeralAccessToken
    }

    public init(twoFactorAuth: Hyphen2FAStatus, ephemeralAccessToken: String) {
        self.twoFactorAuth = twoFactorAuth
        self.ephemeralAccessToken = ephemeralAccessToken
    }
}
