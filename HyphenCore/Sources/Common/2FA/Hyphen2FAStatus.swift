import Foundation

public struct Hyphen2FAStatus: Codable, Equatable, Sendable {
    public let id: String
    public let request: Hyphen2FARequest
    public let status: Hyphen2FAStatusType

    private enum CodingKeys: String, CodingKey {
        case id
        case request
        case status
    }

    public init(id: String, request: Hyphen2FARequest, status: Hyphen2FAStatusType) {
        self.id = id
        self.request = request
        self.status = status
    }
}
