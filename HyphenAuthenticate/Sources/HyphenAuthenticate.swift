import ASN1Kit
import AuthenticationServices
import CryptorECC
// import CBORCoding
import FirebaseAuth
import Foundation
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork
import Moya

public final class HyphenAuthenticate: NSObject {
    public static let shared: HyphenAuthenticate = .init()

    @_spi(HyphenInternal)
    public var authorizationCallback: (ASAuthorization) -> Void = { _ in }

    override private init() {}

    public func authenticate(provider method: HyphenAuthenticateMethod) async throws {
        if method == .google {
            let authCredential = try await HyphenGoogleAuthenticate.shared.authenticate()

            let authResult = try await Auth.auth().signIn(with: authCredential)
            HyphenLogger.shared.logger.info("Add firebase user...")

            HyphenLogger.shared.logger.info("Firebase authenticate successfully. User -> \(authResult.user.displayName ?? "")(\(authResult.user.email ?? ""))")

            let user = authResult.user
            let idToken = try await user.getIDToken()

            HyphenLogger.shared.logger.info("FIDToken -> \(idToken)")

            // process hyphen authenticate process

            do {
                let hyphenAuthenticateResult = try await HyphenNetworking.shared.signIn(token: idToken)
                print(hyphenAuthenticateResult)
            } catch {
                if let convertedMoyaError = error as? MoyaError,
                   let response = convertedMoyaError.response
                {
                    let errorBody = String(data: response.data, encoding: .utf8)
                    if errorBody?.contains("please sign up") == true {
                        HyphenLogger.shared.logger.info("Generating keypair derived from secure enclave...")

                        var error: Unmanaged<CFError>?
                        if let cfdata = SecKeyCopyExternalRepresentation(HyphenCryptography.getPubKey(), &error) {
                            let data: Data = cfdata as Data
                            let publicKey = data.hexEncodedString()

                            print(publicKey)
                            print(publicKey.count)

                            let startIdx = publicKey.index(publicKey.startIndex, offsetBy: 2)
                            let publicKeyResult = String(publicKey[startIdx...])

                            let userKey = await HyphenUserKey(
                                type: .device,
                                device: HyphenDevice(
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

                            do {
                                let result = try await HyphenNetworking.shared.signUp(token: idToken, userKey: userKey)
                                print(result.credentials)
                            } catch {
                                if let convertedMoyaError = error as? MoyaError,
                                   let response = convertedMoyaError.response
                                {
                                    let errorBody = String(data: response.data, encoding: .utf8)
                                    print(errorBody)
                                }
                            }
                        }

//                        let p256PrivateKey = try ECPrivateKey.make(for: .prime256v1)
//                        let publicKeyPemFormat = try p256PrivateKey.extractPublicKey().pemString
//                        let base64FormatAsn1String = publicKeyPemFormat
//                            .replacingOccurrences(of: "\n", with: "")
//                            .replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
//                            .replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
//
//                        let publicKeyRawValue = try ASN1Decoder.decode(asn1: Data(base64Encoded: base64FormatAsn1String)!)
//                        var publicKey = publicKeyRawValue.data.items!.last!.data.primitive!.hexEncodedString()
//                        for _ in 0 ..< 4 {
//                            publicKey.remove(at: publicKey.startIndex)
//                        }
//
//                        print(publicKey)
//                        print(publicKey.count)
//
//                        let accessControl = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil)
//
//
                        // generate passkey, and required sign up
//                        print("UserID -> \(user.uid)")
                        // await createPassKeyAndSignUp(userId: user.uid, email: user.email ?? "")
                    }
                }
            }
        }
    }

//    private func createPassKeyAndSignUp(userId: String, email _: String) async {
//        let challenge = "HelloWorld!".data(using: .utf8)!
//        let userID = userId.data(using: .utf8)!
//
//        if #available(iOS 15.0, *) {
//            let platformProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: "api.dev.hyphen.at")
//            let assertionRequest = platformProvider.createCredentialAssertionRequest(challenge: challenge)
//            // let platformKeyRequest = platformProvider.createCredentialRegistrationRequest(challenge: challenge, name: email, userID: userID)
//
//            authorizationCallback = { authorization in
//                if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialRegistration {
//                    let attestationObject = credential.rawAttestationObject!
//                    let clientDataJSON = credential.rawClientDataJSON
//                    let credentialID = credential.credentialID
//
//                    print(attestationObject.hexEncodedString())
//                    print(clientDataJSON.hexEncodedString())
//                    print(credentialID.hexEncodedString())
//
//                    let decoder = CBORDecoder()
//                    let decodedAttestationObject = try! decoder.decode(AttestationObject.self, from: attestationObject)
//                    let authData = decodedAttestationObject.authData
//
//                    var credentialIDLength: UInt16 = 0
//                    _ = withUnsafeMutableBytes(of: &credentialIDLength) { authData[53 + 30 ... 54 + 30].copyBytes(to: $0) }
//                    credentialIDLength = credentialIDLength.bigEndian
//
//                    let publicKeyData = authData.subdata(in: (55 + 30 + Int(credentialIDLength)) ..< authData.count + 30)
//                    let publicKeyInformation = try! decoder.decode([Int: QuantumValue].self, from: publicKeyData)
//
//                    let keyType = publicKeyInformation[1] // 2 = Elliptic Curve
//                    let keyAlgorithm = publicKeyInformation[3] // -7 = ECDSA with SHA256
//                    let keyCurveType = publicKeyInformation[-1] // 1 = P-256
//
//                    var publicKey = ""
//
//                    switch publicKeyInformation[-2] {
//                    case let .data(data):
//                        publicKey += data.hexEncodedString()
//                        print(data.hexEncodedString()) // Key curve X
//                    default:
//                        break
//                    }
//
//                    switch publicKeyInformation[-3] {
//                    case let .data(data):
//                        publicKey += data.hexEncodedString()
//                        print(data.hexEncodedString()) // Key curve Y
//                    default:
//                        break
//                    }
//
//                    print("PublicKey -> \(publicKey)")
//
    ////                                    else if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
    ////                                        HyphenLogger.shared.logger.info("\(String(data: credential.rawClientDataJSON.base64EncodedData(), encoding: .utf8))")
    ////                                        HyphenLogger.shared.logger.info("\(String(data: credential.rawAuthenticatorData.base64EncodedData(), encoding: .utf8))")
    ////                                        HyphenLogger.shared.logger.info("\(String(data: credential.signature.base64EncodedData(), encoding: .utf8))")
    ////                                    } else {
    ////                                        // Handle other authentication cases, such as Sign in with Apple.
    ////                                    }
//                } else if let credential = authorization.credential as? ASAuthorizationPlatformPublicKeyCredentialAssertion {
//                    print(credential.signature.hexEncodedString())
//                    print(credential.signature.base64EncodedString())
//
    ////                    let attestedCredentialData = credential.rawAuthenticatorData.subdata(in: 37 ..< credential.rawAuthenticatorData.count)
    ////                    print(attestedCredentialData.hexEncodedString())
//                }
//            }
//
//            // let assertionRequest = platformProvider.createCredentialAssertionRequest(challenge: challenge)
//            let authController = ASAuthorizationController(authorizationRequests: [assertionRequest])
//            authController.delegate = self
//            authController.presentationContextProvider = self
//            authController.performRequests()
//        } else {
//            // TODO: LEGACY
//        }
//    }
}

//
//// MARK: - ASAuthorizationControllerDelegate
//
// extension HyphenAuthenticate: ASAuthorizationControllerDelegate {
//    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if #available(iOS 15.0, *) {
//            authorizationCallback(authorization)
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    public func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
//        HyphenLogger.shared.logger.error("\(error)")
//    }
// }
//
//// MARK: - ASAuthorizationControllerPresentationContextProviding
//
// extension HyphenAuthenticate: ASAuthorizationControllerPresentationContextProviding {
//    public func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
//        UIApplication.shared.hyphensdk_currentKeyWindow!
//    }
// }
//
// public extension Data {
//    var bytes: [UInt8] {
//        return [UInt8](self)
//    }
// }
//
// private struct AttestationObject: Codable {
//    let authData: Data
//    let fmt: String
// }
//
// enum QuantumValue: Decodable {
//    case int(Int), string(String), data(Data)
//
//    init(from decoder: Decoder) throws {
//        if let int = try? decoder.singleValueContainer().decode(Int.self) {
//            self = .int(int)
//            return
//        }
//
//        if let string = try? decoder.singleValueContainer().decode(String.self) {
//            self = .string(string)
//            return
//        }
//
//        if let data = try? decoder.singleValueContainer().decode(Data.self) {
//            self = .data(data)
//            return
//        }
//
//        throw QuantumError.missingValue
//    }
//
//    enum QuantumError: Error {
//        case missingValue
//    }
