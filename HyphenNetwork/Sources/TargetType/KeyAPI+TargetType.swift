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
        case let .deletePublicKey(key):
            "/key/v1/keys/\(key)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getKeys:
            .get
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
        }
    }
}
