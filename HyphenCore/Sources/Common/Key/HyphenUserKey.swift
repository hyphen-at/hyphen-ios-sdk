import Foundation

public struct HyphenUserKey: Codable, Equatable, Sendable, Hashable {
    public let type: HyphenUserType
    public let publicKey: String
    public let device: HyphenDevice?
    public let wallet: HyphenSupportWallet?

    private enum CodingKeys: String, CodingKey {
        case type
        case device
        case publicKey
        case wallet
    }

    public init(
        type: HyphenUserType,
        device: HyphenDevice?,
        publicKey: String,
        wallet: HyphenSupportWallet?
    ) {
        self.type = type
        self.device = device
        self.publicKey = publicKey
        self.wallet = wallet
    }
}
