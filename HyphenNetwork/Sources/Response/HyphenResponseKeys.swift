import Foundation
import HyphenCore

struct HyphenResponseKeys: Codable, Hashable, Equatable, Sendable {
    let keys: [HyphenKey]

    enum CodingKeys: String, CodingKey {
        case keys
    }
}
