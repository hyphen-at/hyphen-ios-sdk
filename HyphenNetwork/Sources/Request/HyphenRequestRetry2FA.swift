import Foundation

public struct HyphenRequestRetry2FA: Codable {
    public let destDeviceId: String

    public init(destDeviceId: String) {
        self.destDeviceId = destDeviceId
    }

    enum CodingKeys: String, CodingKey {
        case destDeviceId
    }
}
