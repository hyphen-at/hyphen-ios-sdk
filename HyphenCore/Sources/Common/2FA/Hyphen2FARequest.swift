import Foundation

public struct Hyphen2FARequest: Codable, Equatable, Sendable {
    public let id: String
    public let app: HyphenAppInformation
    public let userOpInfo: Hyphen2FAUserOpInfo
    public let srcDevice: HyphenDevice
    public let destDevice: HyphenDevice
    public let requestedAt: String
    public let message: String

    private enum CodingKeys: String, CodingKey {
        case id
        case app
        case userOpInfo
        case srcDevice
        case destDevice
        case requestedAt
        case message
    }

    public init(
        id: String,
        app: HyphenAppInformation,
        userOpInfo: Hyphen2FAUserOpInfo,
        srcDevice: HyphenDevice,
        destDevice: HyphenDevice,
        requestedAt: String,
        message: String
    ) {
        self.id = id
        self.app = app
        self.userOpInfo = userOpInfo
        self.srcDevice = srcDevice
        self.destDevice = destDevice
        self.requestedAt = requestedAt
        self.message = message
    }
}
