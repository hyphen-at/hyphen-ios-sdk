import FirebaseMessaging
import Foundation
import SecureDefaults

public final class Hyphen: NSObject {
    public static let shared: Hyphen = .init()

    override private init() {
        if !SecureDefaults.shared.isKeyCreated {
            SecureDefaults.shared.password = UUID().uuidString
        }
    }

    private var hyphenAccount: HyphenAccount? = nil

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
        SecureDefaults.standard.set(credential.accessToken, forKey: "at.hyphen.sdk.credential.accessToken")
        SecureDefaults.standard.set(credential.refreshToken, forKey: "at.hyphen.sdk.credential.refreshToken")
    }

    @_spi(HyphenInternalOnlyNetworking)
    public func saveEphemeralAccessToken(_ ephemeralAccessToken: String) {
        SecureDefaults.standard.set(ephemeralAccessToken, forKey: "at.hyphen.sdk.credential.ephemeralAccessToken")
    }

    @_spi(HyphenInternalOnlyNetworking)
    public func clearEphemeralAccessToken() {
        SecureDefaults.standard.removeObject(forKey: "at.hyphen.sdk.credential.ephemeralAccessToken")
    }

    @_spi(HyphenInternalOnlyNetworking)
    public func getCredential() -> HyphenCredential {
        let accessToken = SecureDefaults.standard.object(forKey: "at.hyphen.sdk.credential.accessToken") as! String
        let refreshToken = SecureDefaults.standard.object(forKey: "at.hyphen.sdk.credential.refreshToken") as! String

        return HyphenCredential(accessToken: accessToken, refreshToken: refreshToken)
    }

    @_spi(HyphenInternalOnlyNetworking)
    public func isCredentialExist() -> Bool {
        SecureDefaults.standard.value(forKey: "at.hyphen.sdk.credential.accessToken") != nil && SecureDefaults.standard.value(forKey: "at.hyphen.sdk.credential.refreshToken") != nil
    }

    // TODO: Remove this
    public func saveWalletAddress(_ address: String) {
        SecureDefaults.standard.set(address, forKey: "at.hyphen.sdk.wallet.address")
    }

    public func getWalletAddress() -> String? {
        SecureDefaults.standard.object(forKey: "at.hyphen.sdk.wallet.address") as? String
    }
}
