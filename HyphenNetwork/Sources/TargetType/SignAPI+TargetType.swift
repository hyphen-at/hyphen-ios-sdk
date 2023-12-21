import Foundation
import HyphenCore
import Moya

extension SignAPI: TargetType {
    public var headers: [String: String]? {
        ["Content-type": "application/json"]
    }

    public var baseURL: URL {
        URL(string: HyphenNetworking.shared.baseUrl)!
    }

    public var path: String {
        switch self {
        case .getPayerAddress:
            "/sign/v1/cadence"
        case .signTransactionWithServerKey(message: _):
            "/sign/v1/cadence/transaction"
        case .signTransactionWithPayMasterKey(message: _):
            "/sign/v1/cadence/paymaster"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getPayerAddress:
            .get
        default:
            .post
        }
    }

    public var sampleData: Data {
        switch self {
        default:
            "".data(using: .utf8)!
        }
    }

    public var task: Task {
        switch self {
        case .getPayerAddress:
            return .requestPlain
        case let .signTransactionWithServerKey(message: message):
            let json = try! JSONEncoder().encode(HyphenRequestSign(message: message))
            return .requestData(json)
        case let .signTransactionWithPayMasterKey(message: message):
            let json = try! JSONEncoder().encode(HyphenRequestSign(message: message))
            return .requestData(json)
        }
    }
}
