import Foundation

public struct HyphenRecoverKeyRegistration: Codable, Equatable, Sendable {
    public let publicKey: String
    public let cloudKey: CloudKey?

    public struct CloudKey: Codable, Equatable, Sendable {
        public let accountName: String
    }

    private enum CodingKeys: String, CodingKey {
        case publicKey
        case cloudKey
    }

    public init(publicKey: String, cloudKey: CloudKey?) {
        self.publicKey = publicKey
        self.cloudKey = cloudKey
    }
}
