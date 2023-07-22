import Foundation

public struct HyphenRequestEditDevice: Codable {
    public let id: String?
    public let pushToken: String?
    public let name: String?
    public let osName: String?
    public let osVersion: String?
    public let deviceManufacturer: String?
    public let deviceModel: String?
    public let lang: String?

    public init(
        id: String? = nil,
        pushToken: String? = nil,
        name: String? = nil,
        osName: String? = nil,
        osVersion: String? = nil,
        deviceManufacturer: String? = nil,
        deviceModel: String? = nil,
        lang: String? = nil
    ) {
        self.id = id
        self.pushToken = pushToken
        self.name = name
        self.osName = osName
        self.osVersion = osVersion
        self.deviceManufacturer = deviceManufacturer
        self.deviceModel = deviceModel
        self.lang = lang
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case pushToken
        case name
        case osName
        case osVersion
        case deviceManufacturer
        case deviceModel
        case lang
    }
}
