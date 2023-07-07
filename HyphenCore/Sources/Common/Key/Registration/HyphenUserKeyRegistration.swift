import Foundation

public struct HyphenUserKeyRegistration: Codable, Equatable, Sendable {
    public let publicKey: HyphenPublicKey
    public let type: HyphenUserType
    public let device: HyphenDeviceRegistration?
    public let passKey: HyphenPassKey?
    public let wallet: HyphenSupportWallet?

    private enum CodingKeys: String, CodingKey {
        case publicKey
        case type
        case device
        case passKey
        case wallet
    }

    public init(
        publicKey: HyphenPublicKey,
        type: HyphenUserType,
        device: HyphenDeviceRegistration?,
        passKey: HyphenPassKey?,
        wallet: HyphenSupportWallet?
    ) {
        self.publicKey = publicKey
        self.type = type
        self.device = device
        self.passKey = passKey
        self.wallet = wallet
    }
}
