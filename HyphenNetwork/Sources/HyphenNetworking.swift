import Foundation
import HyphenCore
import Moya

public final class HyphenNetworking: NSObject {
    public static let shared: HyphenNetworking = .init()

    override private init() {}

    @_spi(HyphenInternal)
    public lazy var authProvider: MoyaProvider<AuthAPI> = {
        let provider = MoyaProvider<AuthAPI>(
            session: Session(interceptor: RequiredHeaderInterceptor())
            // plugins: [NetworkLoggerPlugin()]
        )
        return provider
    }()

    @_spi(HyphenInternal)
    public lazy var signProvider: MoyaProvider<SignAPI> = {
        let provider = MoyaProvider<SignAPI>(
            session: Session(interceptor: RequiredHeaderInterceptor())
            // ∂plugins: [NetworkLoggerPlugin()]
        )
        return provider
    }()

    public func signIn(token: String) async throws -> HyphenResponseSignIn {
        let requestPayload = HyphenRequestSignIn(method: "firebase", token: token, chainName: "flow-testnet")
        let response: HyphenResponseSignIn = try await authProvider.async.request(.signIn(payload: requestPayload))

        return response
    }

    public func signUp(token: String, userKey: HyphenUserKey) async throws -> HyphenResponseSignIn {
        let requestPayload = HyphenRequestSignUp(method: "firebase", token: token, chainName: "flow-testnet", userKey: userKey)
        let response: HyphenResponseSignIn = try await authProvider.async.request(.signUp(payload: requestPayload))

        return response
    }

    public func signTransactionWithServerKey(message: String) async throws -> HyphenSignResult {
        print(message)
        return try await signProvider.async.request(.signTransactionWithServerKey(message: message))
    }

    public func signTransactionWithPayMasterKey(message: String) async throws -> HyphenSignResult {
        print(message)
        return try await signProvider.async.request(.signTransactionWithPayMasterKey(message: message))
    }
}
