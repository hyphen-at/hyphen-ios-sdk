import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
@_spi(HyphenInternal) import HyphenCore
import UIKit

public final class HyphenAuthenticateAppDelegate: NSObject {
    public static let shared: HyphenAuthenticateAppDelegate = .init()

    override private init() {}

    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) {
        HyphenLogger.shared.logger.info("[HyphenAAD] Check firebase app initialization...")

        if FirebaseApp.app() == nil {
            HyphenLogger.shared.logger.info("[HyphenAAD] Firebase App is not configurated. Initialize firebase app...")
            FirebaseApp.configure()
            HyphenLogger.shared.logger.info("[HyphenAAD] Firebase App configuration successfully.")
        }
    }

    func application(
        _: UIApplication,
        open url: URL,
        options _: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
