import Foundation
import HyphenCore

public struct HyphenResponseSignIn2FA: Codable, Sendable, Equatable {
    public let twoFactorAuth: Hyphen2FAStatus

    enum CodingKeys: String, CodingKey {
        case twoFactorAuth
    }

    public init(twoFactorAuth: Hyphen2FAStatus) {
        self.twoFactorAuth = twoFactorAuth
    }
}
