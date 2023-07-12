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
        }
    }

    public var method: Moya.Method {
        switch self {
        case .signIn(payload: _):
            return .post
        }
    }

    public var sampleData: Data {
        switch self {
        case .signIn(payload: _):
            return """
            {
              "account": {
                "id": "string",
                "addresses": [
                  {
                    "address": "0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B",
                    "domainName": "vitalik.eth",
                    "chainName": "string",
                    "chainId": 80001,
                    "chainType": "evm"
                  }
                ],
                "parent": [
                  {
                    "address": "0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B",
                    "domainName": "vitalik.eth",
                    "chainName": "string",
                    "chainId": 80001,
                    "chainType": "evm"
                  }
                ],
                "createdAt": "2023-07-12T04:56:55.171Z",
                "updatedAt": "2023-07-12T04:56:55.171Z"
              },
              "credentials": {
                "accessToken": "eyJhbGciOiJIUzI...Qedy-rosPJLzs3jArh6Vc",
                "refreshToken": "eyJhbGciOiJIUzI...Qedy-rosPJLzs3jArh6Vc"
              }
            }
            """.data(using: .utf8)!
        }
    }

    public var task: Task {
        switch self {
        case let .signIn(payload: payload):
            let json = try! JSONEncoder().encode(payload)

            return .requestData(json)
        }
    }
}
