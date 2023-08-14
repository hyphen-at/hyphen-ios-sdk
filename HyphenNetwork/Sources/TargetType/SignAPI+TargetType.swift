import Foundation
import HyphenCore
import Moya

extension SignAPI: TargetType {
    public var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        return URL(string: HyphenNetworking.shared.baseUrl)!
    }

    public var path: String {
        switch self {
        case .signTransactionWithServerKey(message: _):
            return "/sign/v1/cadence/transaction"
        case .signTransactionWithPayMasterKey(message: _):
            return "/sign/v1/cadence/paymaster"
        }
    }

    public var method: Moya.Method {
        .post
    }

    public var sampleData: Data {
        switch self {
        default:
            return "".data(using: .utf8)!
        }
    }

    public var task: Task {
        switch self {
        case let .signTransactionWithServerKey(message: message):
            let json = try! JSONEncoder().encode(HyphenRequestSign(message: message))
            return .requestData(json)
        case let .signTransactionWithPayMasterKey(message: message):
            let json = try! JSONEncoder().encode(HyphenRequestSign(message: message))
            return .requestData(json)
        }
    }
}
