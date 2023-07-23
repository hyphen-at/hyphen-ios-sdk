import Foundation

public struct HyphenRequest2FAFinish: Codable {
    public let twoFactorAuthRequestId: String

    public init(twoFactorAuthRequestId: String) {
        self.twoFactorAuthRequestId = twoFactorAuthRequestId
    }

    enum CodingKeys: String, CodingKey {
        case twoFactorAuthRequestId
    }
}
