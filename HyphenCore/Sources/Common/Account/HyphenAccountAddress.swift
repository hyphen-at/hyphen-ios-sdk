import Foundation

public struct HyphenAccountAddress: Codable, Equatable, Sendable {
    public let chainName: String
    public let chainId: Int?
    public let chainType: HyphenChainType
    public let address: String
    public let domainName: String?

    private enum CodingKeys: String, CodingKey {
        case chainName
        case chainId
        case chainType
        case address
        case domainName
    }

    public init(
        chainName: String,
        chainId: Int?,
        chainType: HyphenChainType,
        address: String,
        domainName: String?
    ) {
        self.chainName = chainName
        self.chainId = chainId
        self.chainType = chainType
        self.address = address
        self.domainName = domainName
    }
}
