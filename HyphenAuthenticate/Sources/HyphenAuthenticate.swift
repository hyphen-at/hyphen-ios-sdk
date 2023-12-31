import AuthenticationServices
import FirebaseAuth
import FirebaseMessaging
import Flow
import Foundation
@_spi(HyphenInternal) import HyphenCore
@_spi(HyphenInternal) import HyphenFlow
import HyphenNetwork
import Moya
import RealEventsBus

typealias Task = _Concurrency.Task

public final class HyphenAuthenticate: NSObject {
    public static let shared: HyphenAuthenticate = .init()

    private var _account: HyphenAccount? = nil

    override private init() {}

    var chainName: String {
        if Hyphen.shared.network == .testnet {
            "flow-testnet"
        } else {
            "flow-mainnet"
        }
    }

    public func getAccount() async throws -> HyphenAccount {
        if let account = _account {
            return account
        }

        let accountResult = try await HyphenNetworking.shared.getMyAccount()
        try await updateDeviceInformation()

        _account = accountResult

        return accountResult
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
                Bus<HyphenEventBusType>.post(.showAccountRecoveryMethodModal)

                let accountRecoveryMethod = try await withUnsafeThrowingContinuation { continuation in
                    Bus<HyphenEventBusType>.register(self) { event in

                        switch event {
                        case .selectAccountRecoveryMethod2FA:
                            continuation.resume(returning: "2fa")
                        case .selectAccountRecoveryMethodRecoveryKey:
                            continuation.resume(returning: "recovery-key")
                        default:
                            break
                        }
                    }
                }

                if accountRecoveryMethod == "2fa" {
                    HyphenLogger.shared.logger.info("User select account recovery option to 2fa.")
                    HyphenLogger.shared.logger.info("Hyphen device key not found! Generate new device key...")

                    HyphenCryptography.generateKey()

                    guard let hyphenUserKey = try await getHyphenUserKey() else {
                        HyphenLogger.shared.logger.critical("Hyphen SDK error occured. unexpected error. getHyphenUserKey() == nil")
                        throw HyphenSdkError.internalSdkError
                    }

                    try await requestSignIn2FA(idToken: idToken, userKey: hyphenUserKey)
                } else {
                    HyphenLogger.shared.logger.info("Request authenticate challenge with recovery key...")

                    let hyphenRecoveryPublicKey = HyphenCryptography.getRecoveryPublicKeyHex()

                    do {
                        let challengeRequest = try await HyphenNetworking.shared.signInChallenge(
                            payload: HyphenRequestSignInChallenge(
                                challengeType: "recoveryKey",
                                request: HyphenRequestSignInChallenge.Request(method: "firebase", token: idToken, chainName: chainName),
                                publicKey: hyphenRecoveryPublicKey
                            )
                        )

                        let challengeData = challengeRequest.challengeData
                        guard let challengeDataSignature = HyphenCryptography.signDataWithRecoveryKey(challengeData.data(using: .utf8)!)?.hexEncodedString() else {
                            HyphenLogger.shared.logger.error("Signing challenge data with recovery key failed.")
                            return
                        }

                        HyphenCryptography.generateKey()
                        guard let hyphenUserKey = try await getHyphenUserKey() else {
                            HyphenLogger.shared.logger.critical("Hyphen SDK error occured. unexpected error. getHyphenUserKey() == nil")
                            throw HyphenSdkError.internalSdkError
                        }

                        let challengeRespondRequest = try await HyphenNetworking.shared.signInChallengeRespond(
                            payload: HyphenRequestSignInChallengeRespond(
                                challengeType: "recoveryKey",
                                challengeData: challengeData,
                                deviceKey: nil,
                                recoveryKey: .init(signature: challengeDataSignature, newDeviceKey: hyphenUserKey)
                            )
                        )

                        _account = challengeRespondRequest.account
                        Hyphen.shared.saveCredential(challengeRespondRequest.credentials)

                        let newDeviceKeyTx = try await HyphenFlow.shared.makeRecoveryKeySignedTransactionPayloadWithoutArguments(
                            hyphenFlowCadence: .init(
                                cadence: """
                                transaction {
                                    prepare(signer: AuthAccount) {
                                        let key = PublicKey(
                                            publicKey: "\(HyphenCryptography.getPublicKeyHex())".decodeHex(),
                                            signatureAlgorithm: SignatureAlgorithm.ECDSA_P256
                                        )
                                        // Set weight of each key as 500 since quorum is 1000. It enables 2-of-N multisig
                                        signer.keys.add(
                                            publicKey: key,
                                            hashAlgorithm: HashAlgorithm.SHA2_256,
                                            weight: 500.0
                                        )
                                    }
                                }
                                """
                            )
                        )
                        let newDeviceKeyTxId = try await flow.sendTransaction(transaction: newDeviceKeyTx)
                        HyphenLogger.shared.logger.info("[HyphenNewDeviceKeyTxId] \(newDeviceKeyTxId)")
                    } catch {
                        print(error)
                    }
                }
            } else {
                HyphenLogger.shared.logger.info("Request authenticate challenge...")

                guard let hyphenUserKey = try await getHyphenUserKey() else {
                    HyphenLogger.shared.logger.critical("Hyphen SDK error occured. unexpected error. getHyphenUserKey() == nil")
                    throw HyphenSdkError.internalSdkError
                }

                do {
                    let challengeRequest = try await HyphenNetworking.shared.signInChallenge(
                        payload: HyphenRequestSignInChallenge(
                            challengeType: "deviceKey",
                            request: HyphenRequestSignInChallenge.Request(method: "firebase", token: idToken, chainName: chainName),
                            publicKey: hyphenUserKey.publicKey!
                        )
                    )

                    let challengeData = challengeRequest.challengeData
                    guard let challengeDataSignature = HyphenCryptography.signData(challengeData.data(using: .utf8)!)?.hexEncodedString() else {
                        HyphenLogger.shared.logger.error("Signing challenge data failed. Maybe user denied biometric authenticate permission deny or mismatch password (biometric method).")
                        return
                    }

                    let challengeRespondRequest = try await HyphenNetworking.shared.signInChallengeRespond(
                        payload: HyphenRequestSignInChallengeRespond(
                            challengeType: "deviceKey",
                            challengeData: challengeData,
                            deviceKey: HyphenRequestSignInChallengeRespond.DeviceKey(signature: challengeDataSignature),
                            recoveryKey: nil
                        )
                    )

                    _account = challengeRespondRequest.account
                    Hyphen.shared.saveCredential(challengeRespondRequest.credentials)
                } catch {
                    HyphenLogger.shared.logger.error("Request challenge failed. Attempting 2FA request for another device...")
                    try await requestSignIn2FA(idToken: idToken, userKey: hyphenUserKey)
                }
            }
        }
    }

    private func updateDeviceInformation() async throws {
        guard let userKey = try await getHyphenUserKey() else {
            HyphenLogger.shared.logger.critical("Hyphen SDK error occured. unexpected error. getHyphenUserKey() == nil")
            throw HyphenSdkError.internalSdkError
        }

        _ = try await HyphenNetworking.shared.editDevice(
            publicKey: userKey.publicKey!,
            payload: HyphenRequestEditDevice(
                pushToken: userKey.device?.pushToken ?? ""
            )
        )

        HyphenLogger.shared.logger.info("Update device information successfully.")
    }

    private func requestSignIn2FA(idToken: String, userKey: HyphenUserKey) async throws {
        do {
            HyphenLogger.shared.logger.info("Request Hyphen 2FA authenticate...")
            _ = try await HyphenNetworking.shared.signIn2FA(
                payload: HyphenRequestSignIn2FA(
                    request: HyphenRequestSignIn2FA.Request(method: "firebase", token: idToken, chainName: chainName),
                    userKey: userKey
                )
            )
            HyphenLogger.shared.logger.info("Request Hyphen 2FA authenticate successfully. Please check your another device.")

            Bus<HyphenEventBusType>.post(.show2FAWaitingProgressModal(isShow: true))

            let requestId: String = try await withUnsafeThrowingContinuation { continuation in
                Bus<HyphenEventBusType>.register(self) { event in

                    switch event {
                    case .twoFactorAuthDenied:
                        HyphenLogger.shared.logger.info("2FA denied.")
                        Bus<HyphenEventBusType>.unregister(self)
                        continuation.resume(throwing: HyphenSdkError.twoFactorDenied)
                    case let .twoFactorAuthApproved(requestId: requestId):
                        HyphenLogger.shared.logger.info("2FA Approved.")
                        Bus<HyphenEventBusType>.unregister(self)
                        continuation.resume(returning: requestId)
                    default:
                        break
                    }
                }
            }

            let result = try await HyphenNetworking.shared.twoFactorFinish(payload: HyphenRequest2FAFinish(twoFactorAuthRequestId: requestId))

            _account = result.account
            Hyphen.shared.saveCredential(result.credentials)
        } catch {
            if let convertedMoyaError = error as? MoyaError,
               let response = convertedMoyaError.response
            {
                let errorBody = String(data: response.data, encoding: .utf8)
                if errorBody?.contains("please sign up") == true {
                    HyphenLogger.shared.logger.error("Request Hyphen 2FA authenticate... - Failed -> Sign up needed.")
                    HyphenLogger.shared.logger.info("Request Hyphen Sign up...")

                    do {
                        let result = try await HyphenNetworking.shared.signUp(
                            payload: HyphenRequestSignUp(
                                method: "firebase",
                                token: idToken,
                                chainName: chainName,
                                userKey: userKey
                            )
                        )

                        _account = result.account

                        Hyphen.shared.saveCredential(result.credentials)

                        HyphenLogger.shared.logger.info("Generate recovery key and register your recovery key...")
                        try await generateRecoveryKeyAndRegisterKey()

                        print(result)
                    } catch {
                        print(error)
                    }
                } else {
                    print(String(data: response.data, encoding: .utf8))
                }
            } else {
                print(error)
                throw error
            }
        }
    }

    private func generateRecoveryKeyAndRegisterKey() async throws {
        HyphenCryptography.generateRecoveryKey()

        let recoveryPublicKeyHex = HyphenCryptography.getRecoveryPublicKeyHex()
        HyphenLogger.shared.logger.info("[RecoveryPublicKey] \(HyphenCryptography.getRecoveryPublicKeyHex())")

        let recoveryAddKeyTx = try await HyphenFlow.shared.makeSignedTransactionPayloadWithoutArguments(
            hyphenFlowCadence: .init(cadence: """
                transaction {
                    prepare(signer: AuthAccount) {
                        let key = PublicKey(
                            publicKey: "\(HyphenCryptography.getRecoveryPublicKeyHex())".decodeHex(),
                            signatureAlgorithm: SignatureAlgorithm.ECDSA_P256
                        )
                        // Set weight of each key as 500 since quorum is 1000. It enables 2-of-N multisig
                        signer.keys.add(
                            publicKey: key,
                            hashAlgorithm: HashAlgorithm.SHA2_256,
                            weight: 500.0
                        )
                    }
                }
            """)
        )

        let recoveryAddKeyTxId = try await flow.sendTransaction(transaction: recoveryAddKeyTx)
        HyphenLogger.shared.logger.info("[AddRecoveryKeyTxId] \(recoveryAddKeyTxId)")

        try await HyphenNetworking.shared.registerRecoveryKey(recoveryPublicKeyHex)
    }

    private func getHyphenUserKey() async throws -> HyphenUserKey? {
        let fcmToken = try await Messaging.messaging().token()
        let publicKey = HyphenCryptography.getPublicKeyHex()
        let userKey = await HyphenUserKey(
            type: .device,
            device: HyphenDevice(
                id: nil,
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
