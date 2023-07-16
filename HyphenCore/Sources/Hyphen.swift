import Foundation

public final class Hyphen: NSObject {
    public static let shared: Hyphen = .init()

    override private init() {}

    public var _appSecret: String = ""

    public var appSecret: String {
        set {
            if _appSecret.isEmpty {
                _appSecret = newValue
                HyphenLogger.shared.logger.info("Hyphen appSecret set successfully.")
            } else {
                HyphenLogger.shared.logger.warning("Hyphen appSecret already setted.")
            }
        }
        get {
            return _appSecret
        }
    }

    public func saveCredential(_ credential: HyphenCredential) {
        UserDefaults.standard.set(credential.accessToken, forKey: "at.hyphen.sdk.credential.accessToken")
        UserDefaults.standard.set(credential.refreshToken, forKey: "at.hyphen.sdk.credential.refreshToken")
    }

    public func isCredentialExist() -> Bool {
        UserDefaults.standard.value(forKey: "at.hyphen.sdk.credential.accessToken") != nil && UserDefaults.standard.value(forKey: "at.hyphen.sdk.credential.refreshToken") != nil
    }
}
