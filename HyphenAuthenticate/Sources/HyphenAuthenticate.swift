import FirebaseAuth
import Foundation
@_spi(HyphenInternal) import HyphenCore

public final class HyphenAuthenticate: NSObject {
    public static let shared: HyphenAuthenticate = .init()

    override private init() {}

    public func authenticate(provider method: HyphenAuthenticateMethod) async throws {
        if method == .google {
            let authCredential = try await HyphenGoogleAuthenticate.shared.authenticate()
            Auth.auth().signIn(with: authCredential) { result, error in
                HyphenLogger.shared.logger.info("Add firebase user...")

                if let error = error {
                    HyphenLogger.shared.logger.error("Firebase authenticate failed.\n\(error)")
                    return
                }

                HyphenLogger.shared.logger.info("Firebase authenticate successfully. User -> \(result!.user.displayName ?? "")(\(result!.user.email ?? ""))")
            }
        }
    }
}
