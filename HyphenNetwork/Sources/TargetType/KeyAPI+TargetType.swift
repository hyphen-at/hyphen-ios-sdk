import Foundation
import HyphenCore
import Moya

extension KeyAPI: TargetType {
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        return URL(string: HyphenNetworking.shared.baseUrl)!
    }

    public var path: String {
        switch self {
        case .getKeys:
            return "/key/v1/keys"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var sampleData: Data {
        "".data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case .getKeys:
            return .requestPlain
        }
    }
}
