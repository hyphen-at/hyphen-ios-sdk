import Foundation

@_spi(HyphenInternal)
public enum KeyAPI {
    case getKeys
    case registerRecoveryKey(_ publicKey: String)
    case deletePublicKey(_ publicKey: String)
}
