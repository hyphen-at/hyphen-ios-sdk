import AuthenticationServices
import FirebaseAuth
import Foundation
@_spi(HyphenInternal) import HyphenCore

public final class HyphenAuthenticate: NSObject, ASAuthorizationControllerDelegate {
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

                let user = result!.user
                user.getIDToken { token, _ in
                    if let idToken = token {
                        HyphenLogger.shared.logger.info("FIDToken -> \(idToken)")

                        let challenge = "TEST".data(using: .utf8)!
                        let userID = result!.user.uid.data(using: .utf8)!

                        if #available(iOS 15.0, *) {
                            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: "api.dev.hyphen.at")
                            // let platformKeyRequest = platformProvider.createCredentialRegistrationRequest(challenge: challenge, name: "\(result!.user.displayName ?? "")(\(result!.user.email ?? ""))", userID: userID)
                            let assertionRequest = platformProvider.createCredentialAssertionRequest(challenge: challenge)
                            let authController = ASAuthorizationController(authorizationRequests: [assertionRequest])
                            authController.delegate = self
                            authController.presentationContextProvider = self
                            authController.performRequests()
                        } else {
                            // TODO: LEGACY
                        }
                    }
                }
            }
        }
    }

    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if #available(iOS 15.0, *) {
            if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
                let attestationObject = credential.rawAttestationObject!
                let clientDataJSON = credential.rawClientDataJSON
                let credentialID = credential.credentialID

            } else if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
                HyphenLogger.shared.logger.info("\(String(data: credential.rawClientDataJSON.base64EncodedData(), encoding: .utf8))")
                HyphenLogger.shared.logger.info("\(String(data: credential.rawAuthenticatorData.base64EncodedData(), encoding: .utf8))")
                HyphenLogger.shared.logger.info("\(String(data: credential.signature.base64EncodedData(), encoding: .utf8))")
            } else {
                // Handle other authentication cases, such as Sign in with Apple.
            }
        } else {
            // Fallback on earlier versions
        }
    }

    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
        HyphenLogger.shared.logger.error("\(error)")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension HyphenAuthenticate: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.hyphensdk_currentKeyWindow!
    }
}
