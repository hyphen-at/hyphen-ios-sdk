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
}
