import AuthenticationServices
// import CryptorECC
// import CBORCoding
import FirebaseAuth
import FirebaseMessaging
import Foundation
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork
import Moya

typealias Task = _Concurrency.Task

public final class HyphenAuthenticate: NSObject {
    public static let shared: HyphenAuthenticate = .init()

//    @_spi(HyphenInternal)
//    public var authorizationCallback: (ASAuthorization) -> Void = { _ in }

    private var _account: HyphenAccount? = nil
    public var account: HyphenAccount? {
        _account
    }

    override private init() {
        super.init()

        Task {
            do {
                self._account = try await HyphenNetworking.shared.getMyAccount()
            } catch {
                print(error)
            }
        }
    }

    public func authenticate(provider method: HyphenAuthenticateMethod) async throws {
        if method == .google {
            let authCredential = try await HyphenGoogleAuthenticate.shared.authenticate()

            let authResult = try await Auth.auth().signIn(with: authCredential)
            HyphenLogger.shared.logger.info("Add firebase user...")

            HyphenLogger.shared.logger.debug("Firebase authenticate successfully. User -> \(authResult.user.displayName ?? "")(\(authResult.user.email ?? ""))")

            let user = authResult.user
            let idToken = try await user.getIDToken()

            HyphenLogger.shared.logger.debug("FIDToken -> \(idToken)")

            if !HyphenCryptography.isDeviceKeyExist() {
                HyphenLogger.shared.logger.info("Hyphen device key not found! Generate new device key...")

                HyphenCryptography.generateKey()

                guard let hyphenUserKey = try await getHyphenUserKey() else {
                    HyphenLogger.shared.logger.critical("Hyphen SDK error occured. unexpected error. getHyphenUserKey() == nil")
                    throw HyphenSdkError.internalSdkError
                }

                do {
                    HyphenLogger.shared.logger.info("Request Hyphen 2FA authenticate...")
                    _ = try await HyphenNetworking.shared.signIn2FA(
                        payload: HyphenRequestSignIn2FA(
                            request: HyphenRequestSignIn2FA.Request(method: "firebase", token: idToken, chainName: "flow-testnet"),
                            userKey: hyphenUserKey
                        )
                    )
                } catch {
                    if let convertedMoyaError = error as? MoyaError,
                       let response = convertedMoyaError.response
                    {
                        let errorBody = String(data: response.data, encoding: .utf8)
                        if errorBody?.contains("please sign up") == true {
                            HyphenLogger.shared.logger.error("Request Hyphen 2FA authenticate... - Failed -> Sign up needed.")
                            HyphenLogger.shared.logger.info("Request Hyphen Sign up...")

                            let result = try await HyphenNetworking.shared.signUp(
                                payload: HyphenRequestSignUp(
                                    method: "firebase",
                                    token: idToken,
                                    chainName: "flow-testnet",
                                    userKey: hyphenUserKey
                                )
                            )

                            _account = result.account
                            
                            print(result)
                        }
                    }
                }
            } else {
                HyphenLogger.shared.logger.info("Request Hyphen 2FA authenticate...")

                guard let hyphenUserKey = try await getHyphenUserKey() else {
                    HyphenLogger.shared.logger.critical("Hyphen SDK error occured. unexpected error. getHyphenUserKey() == nil")
                    throw HyphenSdkError.internalSdkError
                }

                _ = try await HyphenNetworking.shared.signIn2FA(
                    payload: HyphenRequestSignIn2FA(
                        request: HyphenRequestSignIn2FA.Request(method: "firebase", token: idToken, chainName: "flow-testnet"),
                        userKey: hyphenUserKey
                    )
                )
            }

            // process hyphen authenticate process

//            do {
//                let result = try await HyphenNetworking.shared.signIn(token: idToken)
//                Hyphen.shared.saveCredential(result.credentials)
//                Hyphen.shared.saveWalletAddress(result.account.addresses.first!.address)
//                print(result)
//            } catch {
//                if let convertedMoyaError = error as? MoyaError,
//                   let response = convertedMoyaError.response
//                {
//                    let errorBody = String(data: response.data, encoding: .utf8)
//                    if errorBody?.contains("please sign up") == true {
//                        var error: Unmanaged<CFError>?
//                        if let cfdata = SecKeyCopyExternalRepresentation(HyphenCryptography.getPubKey(), &error) {
//                            let data: Data = cfdata as Data
//                            let publicKey = data.hexEncodedString()
//
//                            print(publicKey)
//                            print(publicKey.count)
//
//                            let startIdx = publicKey.index(publicKey.startIndex, offsetBy: 2)
//                            let publicKeyResult = String(publicKey[startIdx...])
//
//                            let userKey = await HyphenUserKey(
//                                type: .device,
//                                device: HyphenDevice(
//                                    name: UIDevice.current.name,
//                                    osName: .iOS,
//                                    osVersion: HyphenDeviceInformation.osVersion,
//                                    deviceManufacturer: "Apple",
//                                    deviceModel: HyphenDeviceInformation.modelName,
//                                    lang: Locale.preferredLanguages[0],
//                                    type: .mobile
//                                ),
//                                publicKey: publicKeyResult,
//                                wallet: nil
//                            )
//
//                            do {
//                                let result = try await HyphenNetworking.shared.signUp(token: idToken, userKey: userKey)
//                                Hyphen.shared.saveCredential(result.credentials)
//                                Hyphen.shared.saveWalletAddress(result.account.addresses.first!.address)
//
//                                print(result)
//                            } catch {
//                                if let convertedMoyaError = error as? MoyaError,
//                                   let response = convertedMoyaError.response
//                                {
//                                    let errorBody = String(data: response.data, encoding: .utf8)
//                                    print(errorBody)
//                                }
//
//                                throw error
//                            }
//                        }
        }
    }

    private func getHyphenUserKey() async throws -> HyphenUserKey? {
        let fcmToken = try await Messaging.messaging().token()

        var error: Unmanaged<CFError>?
        guard let cfdata = SecKeyCopyExternalRepresentation(HyphenCryptography.getPubKey(), &error) else {
            return nil
        }

        guard error == nil else {
            return nil
        }

        let data: Data = cfdata as Data
        let encodedPublicKey = data.hexEncodedString()

        let startIdx = encodedPublicKey.index(encodedPublicKey.startIndex, offsetBy: 2)
        let publicKey = String(encodedPublicKey[startIdx...])

        let userKey = await HyphenUserKey(
            type: .device,
            device: HyphenDevice(
                publicKey: publicKey,
                pushToken: fcmToken,
                name: UIDevice.current.name,
                osName: .iOS,
                osVersion: HyphenDeviceInformation.osVersion,
                deviceManufacturer: "Apple",
                deviceModel: HyphenDeviceInformation.modelName,
                lang: Locale.preferredLanguages[0],
                type: .mobile
            ),
            publicKey: publicKey,
            wallet: nil
        )

        return userKey
    }
}
