import Foundation

public struct HyphenDevice: Codable, Equatable, Sendable, Hashable {
    public let publicKey: String
    public let pushToken: String
    public let name: String
    public let osName: HyphenOSName
    public let osVersion: String
    public let deviceManufacturer: String
    public let deviceModel: String
    public let lang: String
    public let type: HyphenDeviceType

    enum CodingKeys: String, CodingKey {
        case publicKey
        case pushToken
        case name
        case osName
        case osVersion
        case deviceManufacturer
        case deviceModel
        case lang
        case type
    }

    public init(
        publicKey: String,
        pushToken: String,
        name: String,
        osName: HyphenOSName,
        osVersion: String,
        deviceManufacturer: String,
        deviceModel: String,
        lang: String,
        type: HyphenDeviceType
    ) {
        self.publicKey = publicKey
        self.pushToken = pushToken
        self.name = name
        self.osName = osName
        self.osVersion = osVersion
        self.deviceManufacturer = deviceManufacturer
        self.deviceModel = deviceModel
        self.lang = lang
        self.type = type
    }
}
