import Foundation
import HyphenCore

struct HyphenRequestRegisterRecoveryKey: Codable {
    let recoveryKey: RecoveryKeyRegistration

    struct RecoveryKeyRegistration: Codable {
        let publicKey: HyphenPublicKey
        let cloudKey: CloudKey

        struct CloudKey: Codable {
            let accountName: String

            private enum CodingKeys: String, CodingKey {
                case accountName
            }
        }

        enum CodingKeys: CodingKey {
            case publicKey
            case cloudKey
        }
    }

    enum CodingKeys: CodingKey {
        case recoveryKey
    }
}
