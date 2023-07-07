import Foundation

public struct HyphenUserKey: Codable, Equatable, Sendable {
    public let type: HyphenUserType
    public let device: HyphenDevice?
    public let passKey: HyphenPassKey?
    public let wallet: HyphenSupportWallet?

    private enum CodingKeys: String, CodingKey {
        case type
        case device
        case passKey
        case wallet
    }

    public init(
        type: HyphenUserType,
        device: HyphenDevice?,
        passKey: HyphenPassKey?,
        wallet: HyphenSupportWallet?
    ) {
        self.type = type
        self.device = device
        self.passKey = passKey
        self.wallet = wallet
    }
}
