import Foundation
import HyphenCore

public struct HyphenResponseSignIn: Codable, Sendable, Equatable {
    public let account: HyphenAccount
    public let credentials: HyphenCredential
    public let transaction: HyphenTransaction?

    private enum CodingKeys: String, CodingKey {
        case account
        case credentials
        case transaction
    }

    public init(account: HyphenAccount, credentials: HyphenCredential, transaction: HyphenTransaction?) {
        self.account = account
        self.credentials = credentials
        self.transaction = transaction
    }
}
