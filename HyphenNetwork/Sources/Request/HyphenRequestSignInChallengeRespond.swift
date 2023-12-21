import Foundation
import HyphenCore

public struct HyphenRequestSignInChallengeRespond: Codable, Hashable, Equatable, Sendable {
    public let challengeType: String
    public let challengeData: String
    public let deviceKey: HyphenRequestSignInChallengeRespond.DeviceKey?
    public let recoveryKey: HyphenRequestSignInChallengeRespond.RecoveryKey?

    public struct DeviceKey: Codable, Hashable, Equatable, Sendable {
        public let signature: String

        public init(signature: String) {
            self.signature = signature
        }

        enum CodingKeys: CodingKey {
            case signature
        }
    }

    public struct RecoveryKey: Codable, Hashable, Equatable, Sendable {
        public let signature: String
        public let newDeviceKey: HyphenUserKey

        public init(signature: String, newDeviceKey: HyphenUserKey) {
            self.signature = signature
            self.newDeviceKey = newDeviceKey
        }

        enum CodingKeys: CodingKey {
            case signature
            case newDeviceKey
        }
    }

    public init(challengeType: String, challengeData: String, deviceKey: HyphenRequestSignInChallengeRespond.DeviceKey?, recoveryKey: HyphenRequestSignInChallengeRespond.RecoveryKey?) {
        self.challengeType = challengeType
        self.challengeData = challengeData
        self.deviceKey = deviceKey
        self.recoveryKey = recoveryKey
    }

    enum CodingKeys: CodingKey {
        case challengeType
        case challengeData
        case deviceKey
        case recoveryKey
    }
}
