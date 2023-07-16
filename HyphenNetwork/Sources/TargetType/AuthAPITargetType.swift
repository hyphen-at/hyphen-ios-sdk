import Foundation
import HyphenCore
import Moya

extension AuthAPI: TargetType {
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        return URL(string: "https://api.dev.hyphen.at")!
    }

    public var path: String {
        switch self {
        case .signIn(payload: _):
            return "/auth/v1/signin"
        case .signUp(payload: _):
            return "/auth/v1/signup"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .signIn(payload: _):
            fallthrough
        case .signUp(payload: _):
            return .post
        }
    }

    public var sampleData: Data {
        switch self {
        default:
            return "".data(using: .utf8)!
        }
    }

    public var task: Task {
        switch self {
        case let .signIn(payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        case let .signUp(payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        }
    }
}
