import FirebaseMessaging
import Foundation

public final class Hyphen: NSObject {
    public static let shared: Hyphen = .init()

    override private init() {}

    private var _appSecret: String = ""

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

    private var _apnsToken: Data? = nil

    public var apnsToken: Data? {
        set {
            _apnsToken = newValue
            Messaging.messaging().apnsToken = newValue
        }
        @available(*, unavailable)
        get {
            _apnsToken
        }
    }

    public func saveCredential(_ credential: HyphenCredential) {
        UserDefaults.standard.set(credential.accessToken, forKey: "at.hyphen.sdk.credential.accessToken")
        UserDefaults.standard.set(credential.refreshToken, forKey: "at.hyphen.sdk.credential.refreshToken")
    }

    @_spi(HyphenInternal)
    public func getCredential() -> HyphenCredential {
        let accessToken = UserDefaults.standard.object(forKey: "at.hyphen.sdk.credential.accessToken") as! String
        let refreshToken = UserDefaults.standard.object(forKey: "at.hyphen.sdk.credential.refreshToken") as! String

        return HyphenCredential(accessToken: accessToken, refreshToken: refreshToken)
    }

    public func isCredentialExist() -> Bool {
        UserDefaults.standard.value(forKey: "at.hyphen.sdk.credential.accessToken") != nil && UserDefaults.standard.value(forKey: "at.hyphen.sdk.credential.refreshToken") != nil
    }

    // TODO: Remove this
    public func saveWalletAddress(_ address: String) {
        UserDefaults.standard.set(address, forKey: "at.hyphen.sdk.wallet.address")
    }

    public func getWalletAddress() -> String? {
        UserDefaults.standard.object(forKey: "at.hyphen.sdk.wallet.address") as? String
    }
}
