import Foundation
import Moya

public enum AuthAPI {
    case signIn2FA(payload: HyphenRequestSignIn2FA)
    case signUp(payload: HyphenRequestSignUp)
}
