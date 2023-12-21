import Foundation

struct HyphenResponseCadence: Codable {
    let payerAddress: String
    let payerKeyIndex: Int

    enum CodingKeys: CodingKey {
        case payerAddress
        case payerKeyIndex
    }
}
