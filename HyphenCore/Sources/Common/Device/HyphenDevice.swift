import Foundation

public struct HyphenDevice: Codable, Equatable, Sendable {
    public let name: String
    public let osName: HyphenOSName
    public let osVersion: String
    public let deviceManufacturer: String
    public let deviceModel: String
    public let lang: String
    public let type: HyphenDeviceType

    enum CodingKeys: String, CodingKey {
        case name
        case osName
        case osVersion
        case deviceManufacturer
        case deviceModel
        case lang
        case type
    }

    public init(
        name: String,
        osName: HyphenOSName,
        osVersion: String,
        deviceManufacturer: String,
        deviceModel: String,
        lang: String,
        type: HyphenDeviceType
    ) {
        self.name = name
        self.osName = osName
        self.osVersion = osVersion
        self.deviceManufacturer = deviceManufacturer
        self.deviceModel = deviceModel
        self.lang = lang
        self.type = type
    }
}
