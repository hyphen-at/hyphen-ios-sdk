import Foundation
import HyphenCore
import Moya

// MARK: - Hyphen Auth API

public extension HyphenNetworking {
    func signIn2FA(payload: HyphenRequestSignIn2FA) async throws -> HyphenResponseSignIn2FA {
        let response: HyphenResponseSignIn2FA = try await authProvider.async.request(.signIn2FA(payload: payload))

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
}
