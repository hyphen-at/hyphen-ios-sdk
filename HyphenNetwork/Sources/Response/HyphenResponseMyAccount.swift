import Foundation
import HyphenCore

struct HyphenResponseMyAccount: Codable, Hashable, Equatable, Sendable {
    let account: HyphenAccount

    enum CodingKeys: String, CodingKey {
        case account
    }
}
