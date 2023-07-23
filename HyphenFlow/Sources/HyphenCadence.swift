import Foundation

public struct HyphenFlowCadence: Codable, Equatable, Hashable, Sendable {
    public let cadence: String

    public init(cadence: String) {
        self.cadence = cadence
    }

    enum CodingKeys: String, CodingKey {
        case cadence
    }
}
