import Foundation

@_spi(HyphenInternal)
public enum DeviceAPI {
    case editDevice(publicKey: String, payload: HyphenRequestEditDevice)
    case retry2FA(id: String, payload: HyphenRequestRetry2FA)
    case deny2FA(id: String)
    case approve2FA(id: String, payload: HyphenRequest2FAApprove)
}
