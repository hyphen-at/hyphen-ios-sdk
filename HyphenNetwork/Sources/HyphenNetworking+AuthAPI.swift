import Foundation
@_spi(HyphenInternalOnlyNetworking) import HyphenCore
import Moya

// MARK: - Hyphen Auth API

public extension HyphenNetworking {
    func signIn2FA(payload: HyphenRequestSignIn2FA) async throws -> HyphenResponseSignIn2FA {
        let response: HyphenResponseSignIn2FA = try await authProvider.async.request(.signIn2FA(payload: payload))

        if let ephemeralAccessToken = response.ephemeralAccessToken {
            Hyphen.shared.saveEphemeralAccessToken(ephemeralAccessToken)
        }

        return response
    }

    func signInChallenge(payload: HyphenRequestSignInChallenge) async throws -> HyphenResponseSignInChallenge {
        let response: HyphenResponseSignInChallenge = try await authProvider.async.request(.signInChallenge(payload: payload))

        return response
    }

    func signInChallengeRespond(payload: HyphenRequestSignInChallengeRespond) async throws -> HyphenResponseSignIn {
        let response: HyphenResponseSignIn = try await authProvider.async.request(.signInChallengeRespond(payload: payload))

        return response
    }

    func signUp(payload: HyphenRequestSignUp) async throws -> HyphenResponseSignIn {
        let response: HyphenResponseSignIn = try await authProvider.async.request(.signUp(payload: payload))

        return response
    }

    func twoFactorFinish(payload: HyphenRequest2FAFinish) async throws -> HyphenResponseSignIn {
        let response: HyphenResponseSignIn = try await authProvider.async.request(.twoFactorFinish(payload: payload))

        return response
    }
}
