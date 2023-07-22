import Foundation

public struct Hyphen2FAUserOpInfo: Codable, Equatable, Sendable, Hashable {
    public let type: String
    public let signIn: Hyphen2FAUserOpInfo.SignIn

    enum CodingKeys: String, CodingKey {
        case type
        case signIn
    }

    public init(type: String, signIn: Hyphen2FAUserOpInfo.SignIn) {
        self.type = type
        self.signIn = signIn
    }

    public struct SignIn: Codable, Equatable, Sendable, Hashable {
        public let location: String
        public let ip: String
        public let email: String

        enum CodingKeys: String, CodingKey {
            case location
            case ip
            case email
        }

        public init(location: String, ip: String, email: String) {
            self.location = location
            self.ip = ip
            self.email = email
        }
    }
}
