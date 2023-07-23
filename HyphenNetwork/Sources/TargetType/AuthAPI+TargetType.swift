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
        case .signIn2FA(payload: _):
            return "/auth/v1/signin/2fa"
        case .signInChallenge(payload: _):
            return "/auth/v1/signin/challenge"
        case .signInChallengeRespond(payload: _):
            return "/auth/v1/signin/challenge/respond"
        case .signUp(payload: _):
            return "/auth/v1/signup"
        }
    }

    public var method: Moya.Method {
        .post
    }

    public var sampleData: Data {
        "".data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case let .signIn2FA(payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        case let .signInChallenge(payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        case let .signInChallengeRespond(payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        case let .signUp(payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        }
    }
}
