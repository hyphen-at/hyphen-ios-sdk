import Foundation
import HyphenCore
import Moya

extension AccountAPI: TargetType {
    public var headers: [String: String]? {
        ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        URL(string: HyphenNetworking.shared.baseUrl)!
    }

    public var path: String {
        switch self {
        case .getMyAccount:
            "/account/v1/me"
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
        case .getMyAccount:
            .requestPlain
        }
    }
}
