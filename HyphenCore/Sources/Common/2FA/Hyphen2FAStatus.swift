import Foundation

public struct Hyphen2FAStatus: Codable, Equatable, Sendable {
    public let id: String
    public let accountId: String
    public let request: Hyphen2FARequest
    public let status: Hyphen2FAStatusType
    public let expiresAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case accountId
        case request
        case status
        case expiresAt
    }

    public init(
        id: String,
        accountId: String,
        request: Hyphen2FARequest,
        status: Hyphen2FAStatusType,
        expiresAt: String
    ) {
        self.id = id
        self.accountId = accountId
        self.request = request
        self.status = status
        self.expiresAt = expiresAt
    }
}
