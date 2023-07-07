import Foundation

public struct HyphenAppInformation: Codable, Equatable, Sendable {
    public let appId: String
    public let appName: String

    public init(appId: String, appName: String) {
        self.appId = appId
        self.appName = appName
    }

    enum CodingKeys: String, CodingKey {
        case appId
        case appName
    }
}
