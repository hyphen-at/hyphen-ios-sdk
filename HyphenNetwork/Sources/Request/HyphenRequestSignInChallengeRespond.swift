import Foundation

public struct HyphenRequestSignInChallengeRespond: Codable, Hashable, Equatable, Sendable {
    public let challengeType: String
    public let challengeData: String
    public let deviceKey: HyphenRequestSignInChallengeRespond.DeviceKey

    public struct DeviceKey: Codable, Hashable, Equatable, Sendable {
        public let signature: String

        public init(signature: String) {
            self.signature = signature
        }

        enum CodingKeys: String, CodingKey {
            case signature
        }
    }

    public init(challengeType: String, challengeData: String, deviceKey: DeviceKey) {
        self.challengeType = challengeType
        self.challengeData = challengeData
        self.deviceKey = deviceKey
    }

    enum CodingKeys: String, CodingKey {
        case challengeType
        case challengeData
        case deviceKey
    }
}
