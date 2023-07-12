import Foundation

public struct HyphenCredential: Codable, Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String

    private enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
    }

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
