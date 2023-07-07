import Foundation

public struct Hyphen2FARequest: Codable, Equatable, Sendable {
    public let id: String
    public let app: HyphenAppInformation
    public let srcDevice: HyphenDevice
    public let destDevice: HyphenDevice
    public let requestedAt: String
    public let requestLocation: String

    private enum CodingKeys: String, CodingKey {
        case id
        case app
        case srcDevice
        case destDevice
        case requestedAt
        case requestLocation
    }

    public init(
        id: String,
        app: HyphenAppInformation,
        srcDevice: HyphenDevice,
        destDevice: HyphenDevice,
        requestedAt: String,
        requestLocation: String
    ) {
        self.id = id
        self.app = app
        self.srcDevice = srcDevice
        self.destDevice = destDevice
        self.requestedAt = requestedAt
        self.requestLocation = requestLocation
    }
}
