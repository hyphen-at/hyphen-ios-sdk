import Foundation

public enum HyphenSdkError: Error {
    case notInitialized
    case googleAuthError

    case unauthorized

    case twoFactorDenied

    case internalSdkError
}
