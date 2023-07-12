import Foundation
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

    public func signIn(token: String) async throws -> HyphenResponseSignIn {
        let requestPayload = HyphenRequestSignIn(method: "firebase", token: token, chainName: "flow-testnet")
        let response: HyphenResponseSignIn = try await authProvider.async.request(.signIn(payload: requestPayload))

        return response
    }
}
