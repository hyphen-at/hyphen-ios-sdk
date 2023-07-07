import Foundation

public struct HyphenDeviceRegistration: Codable, Equatable, Sendable {
    let osName: HyphenOSName
    let osVersion: String
    let deviceManufacturer: String
    let deviceModel: String
    let lang: String

    enum CodingKeys: String, CodingKey {
        case osName
        case osVersion
        case deviceManufacturer
        case deviceModel
        case lang
    }

    public init(
        osName: HyphenOSName,
        osVersion: String,
        deviceManufacturer: String,
        deviceModel: String,
        lang: String
    ) {
        self.osName = osName
        self.osVersion = osVersion
        self.deviceManufacturer = deviceManufacturer
        self.deviceModel = deviceModel
        self.lang = lang
    }
}
