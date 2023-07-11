import FirebaseAuth
import FirebaseCore
import GoogleSignIn
@_spi(HyphenInternal) import HyphenCore
import UIKit

@MainActor
final class HyphenGoogleAuthenticate: NSObject {
    static let shared: HyphenGoogleAuthenticate = .init()

    override private init() {}

    func authenticate() async throws -> AuthCredential {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            HyphenLogger.shared.logger.critical("Firebase app is not initialized.")
            throw HyphenSdkError.notInitialized
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        HyphenLogger.shared.logger.info("Authenticate with google...")

        return try await withUnsafeThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.hyphensdk_currentKeyWindowPresentedController!) { [unowned self] result, error in
                guard error == nil else {
                    continuation.resume(throwing: error!)
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else {
                    continuation.resume(throwing: HyphenSdkError.googleAuthError)
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: user.accessToken.tokenString)

                HyphenLogger.shared.logger.info("GoogleIDToken result -> \(idToken)")

                continuation.resume(returning: credential)
            }
        }
    }
}
