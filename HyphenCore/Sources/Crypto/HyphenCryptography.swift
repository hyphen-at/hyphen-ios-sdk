import CryptoKit
import Foundation
import Security

public class HyphenCryptography: NSObject {
    override private init() {}

    static let privTag = Bundle.main.bundleIdentifier!
    static let SecureEnclaveAccess = SecAccessControlCreateWithFlags(
        kCFAllocatorDefault,
        kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        [.biometryAny, .privateKeyUsage],
        nil
    )

    static var EnclaveAttribute: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        kSecAttrKeySizeInBits as String: 256,
        kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
        kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrAccessControl as String: SecureEnclaveAccess!,
        ],
    ]

    // kSecAttrAccessControl as String:    access
    static var NonEnclaveAttribute: [String: Any] = [
        kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
        kSecAttrKeySizeInBits as String: 256,
        kSecPrivateKeyAttrs as String: [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privTag,
        ],
    ]

    public class func isDeviceKeyExist() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        return status == errSecSuccess
    }

    public class func getPubKey() -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status != errSecSuccess {
            HyphenLogger.shared.logger.error("priv key get failed.. generate new key")
            generateKey()
            SecItemCopyMatching(query as CFDictionary, &result)
        }
        let privKey: SecKey = result as! SecKey
        let pubKey = SecKeyCopyPublicKey(privKey)!
        return pubKey
    }

    @_spi(HyphenInternal)
    public class func getPrivKey() -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true,
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status != errSecSuccess {
            HyphenLogger.shared.logger.error("priv key get failed.. generate new key")
            SecItemDelete(query as CFDictionary)
            generateKey()
            let new = SecItemCopyMatching(query as CFDictionary, &result)
            print(new)
        }
        let privKey: SecKey = result as! SecKey
        return privKey
    }

    public class func signData(_ data: Data) -> Data? {
        let algorithm = SecKeyAlgorithm.ecdsaSignatureMessageX962SHA256
        let derSignature = SecKeyCreateSignature(getPrivKey(), algorithm, data as CFData, nil) as? Data

        if let sig = derSignature {
            return try! P256.Signing.ECDSASignature(derRepresentation: sig).rawRepresentation
        } else {
            return nil
        }
    }

    public class func deleteKey() {
        let Privquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: privTag,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true,
        ]
        let code = SecItemDelete(Privquery as CFDictionary)
        if code == errSecSuccess {
            HyphenLogger.shared.logger.info("Key Delete Complete!")
        } else {
            HyphenLogger.shared.logger.error("Delete Failed!!")
            print(code)
        }
    }

    @_spi(HyphenInternal)
    public class func generateKeyNoEnclave() {
        var error: Unmanaged<CFError>?
        // if device has not secure enclave, create normal keypair and save normal keychain
        _ = SecKeyCreateRandomKey(NonEnclaveAttribute as CFDictionary, &error)
    }

    @_spi(HyphenInternal)
    public class func generateKey() {
        var error: Unmanaged<CFError>?
        var privKey = SecKeyCreateRandomKey(EnclaveAttribute as CFDictionary, &error) // create Secure Enclave keypair
        if privKey == nil { // if device has not secure enclave
            HyphenLogger.shared.logger.critical("Secure Enclave Not Supported.")
            privKey = SecKeyCreateRandomKey(NonEnclaveAttribute as CFDictionary, &error)
        }
    }

    @_spi(HyphenInternal)
    public class func encrypt(input: String) -> String? {
        let pubKey: SecKey = getPubKey()
        var error: Unmanaged<CFError>?

        let plain: CFData = input.data(using: .utf8)! as CFData
        let encData = SecKeyCreateEncryptedData(pubKey, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, plain, &error)
        var tdata: Data
        if encData == nil {
            print("encrypt error!!!")
            return nil
        } else {
            tdata = encData! as Data
        }

        let b64result = tdata.base64EncodedString()
        return b64result
    }

    @_spi(HyphenInternal)
    public class func decrypt(input: String) -> String? {
        let privKey: SecKey = getPrivKey()
        guard let encData = Data(base64Encoded: input) else {
            print("decrypt error!!!")
            return nil
        }
        var error: Unmanaged<CFError>?
        let decData = SecKeyCreateDecryptedData(privKey, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, encData as CFData, &error)
        var tdata: Data

        if decData == nil {
            print("decrypt error!!!")
            return nil
        } else {
            tdata = decData! as Data
        }

        let decResult = String(data: tdata, encoding: .utf8)!
        return decResult
    }

    public class func getPublicKeyHex() -> String {
        var error: Unmanaged<CFError>?
        guard let cfdata = SecKeyCopyExternalRepresentation(getPubKey(), &error) else {
            return ""
        }

        guard error == nil else {
            return ""
        }

        let data: Data = cfdata as Data
        let encodedPublicKey = data.hexEncodedString()

        let startIdx = encodedPublicKey.index(encodedPublicKey.startIndex, offsetBy: 2)
        let publicKey = String(encodedPublicKey[startIdx...])

        return publicKey
    }
}
