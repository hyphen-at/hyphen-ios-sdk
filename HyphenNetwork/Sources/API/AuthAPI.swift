import Foundation

@_spi(HyphenInternal)
public enum AuthAPI {
    case signIn2FA(payload: HyphenRequestSignIn2FA)
    case signInChallenge(payload: HyphenRequestSignInChallenge)
    case signInChallengeRespond(payload: HyphenRequestSignInChallengeRespond)

    case signUp(payload: HyphenRequestSignUp)

    case twoFactorFinish(payload: HyphenRequest2FAFinish)
}
