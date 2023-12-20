import Foundation
import HyphenCore
import Moya

extension KeyAPI: TargetType {
    public var headers: [String: String]? {
        ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        URL(string: HyphenNetworking.shared.baseUrl)!
    }

    public var path: String {
        switch self {
        case .getKeys:
            "/key/v1/keys"
        case .registerRecoveryKey:
            "/key/v1/recovery"
        case let .deletePublicKey(key):
            "/key/v1/keys/\(key)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getKeys:
            .get
        case .registerRecoveryKey:
            .post
        case .deletePublicKey:
            .delete
        }
    }

    public var sampleData: Data {
        "".data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case .getKeys:
            fallthrough
        case .deletePublicKey:
            return .requestPlain
        case let .registerRecoveryKey(pubKey):
            let json = try! JSONEncoder().encode(
                HyphenRequestRegisterRecoveryKey(
                    recoveryKey: .init(
                        publicKey: pubKey,
                        cloudKey: .init(accountName: "iCloud")
                    )
                )
            )
            return .requestData(json)
        }
    }
}
