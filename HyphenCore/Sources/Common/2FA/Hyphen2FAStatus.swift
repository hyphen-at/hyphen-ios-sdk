import Foundation

public struct Hyphen2FAStatus: Codable, Equatable, Sendable {
    public let id: String
    public let accountId: String
    public let request: Hyphen2FARequest
    public let status: Hyphen2FAStatusType
    public let expiresAt: String
    public let result: Hyphen2FAStatus.Result

    enum CodingKeys: String, CodingKey {
        case id
        case accountId
        case request
        case status
        case expiresAt
        case result
    }

    public init(
        id: String,
        accountId: String,
        request: Hyphen2FARequest,
        status: Hyphen2FAStatusType,
        expiresAt: String,
        result: Hyphen2FAStatus.Result
    ) {
        self.id = id
        self.accountId = accountId
        self.request = request
        self.status = status
        self.expiresAt = expiresAt
        self.result = result
    }

    public struct Result: Codable, Equatable, Sendable {
        public let signature: String

        enum CodingKeys: String, CodingKey {
            case signature
        }

        public init(signature: String) {
            self.signature = signature
        }
    }
}
