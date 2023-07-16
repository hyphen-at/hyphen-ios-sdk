import Foundation

public struct HyphenRequestSign: Codable, Sendable, Hashable {
    public let message: String

    enum CodingKeys: String, CodingKey {
        case message
    }
}
