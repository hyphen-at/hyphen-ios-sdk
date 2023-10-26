import Foundation
import HyphenCore
import Moya

extension DeviceAPI: TargetType {
    public var headers: [String: String]? {
        ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        URL(string: HyphenNetworking.shared.baseUrl)!
    }

    public var path: String {
        switch self {
        case let .editDevice(publicKey: publicKey, payload: _):
            "/device/v1/devices/\(publicKey)"
        case let .retry2FA(id: id, payload: _):
            "/device/v1/2fa/\(id)"
        case let .deny2FA(id: id):
            "/device/v1/2fa/\(id)"
        case let .approve2FA(id: id, payload: _):
            "/device/v1/2fa/\(id)/approve"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .editDevice(publicKey: _, payload: _):
            fallthrough
        case .retry2FA(id: _, payload: _):
            return .put
        case .deny2FA(id: _):
            return .delete
        case .approve2FA(id: _, payload: _):
            return .post
        }
    }

    public var sampleData: Data {
        "".data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case let .editDevice(publicKey: _, payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        case let .retry2FA(id: _, payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        case .deny2FA(id: _):
            return .requestPlain
        case let .approve2FA(id: _, payload: payload):
            let json = try! JSONEncoder().encode(payload)
            return .requestData(json)
        }
    }
}
