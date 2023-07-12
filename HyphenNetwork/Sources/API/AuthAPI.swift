import Foundation
import Moya

public enum AuthAPI {
    case signIn(payload: HyphenRequestSignIn)
}
