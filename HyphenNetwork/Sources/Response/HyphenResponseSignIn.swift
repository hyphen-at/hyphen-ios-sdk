import Foundation
import HyphenCore

public struct HyphenResponseSignIn: Codable, Sendable, Equatable {
    public let account: HyphenAccount
    public let credentials: HyphenCredential

    private enum CodingKeys: String, CodingKey {
        case account
        case credentials
    }

    public init(account: HyphenAccount, credentials: HyphenCredential) {
        self.account = account
        self.credentials = credentials
    }
}
