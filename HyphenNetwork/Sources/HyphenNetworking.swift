import Foundation
import HyphenCore
import Moya

public final class HyphenNetworking: NSObject {
    public static let shared: HyphenNetworking = .init()

    override private init() {}

    public var baseUrl: String {
        if Hyphen.shared.network == .testnet {
            "https://api.dev.hyphen.at"
        } else {
            "https://api.hyphen.at"
        }
    }

    lazy var authProvider: MoyaProvider<AuthAPI> = {
        let provider = MoyaProvider<AuthAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor()),
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        return provider
    }()

    lazy var deviceProvider: MoyaProvider<DeviceAPI> = {
        let provider = MoyaProvider<DeviceAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor()),
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        return provider
    }()

    lazy var signProvider: MoyaProvider<SignAPI> = {
        let provider = MoyaProvider<SignAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor()),
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        return provider
    }()

    lazy var accountProvider: MoyaProvider<AccountAPI> = {
        let provider = MoyaProvider<AccountAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor()),
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        return provider
    }()

    lazy var keyProvider: MoyaProvider<KeyAPI> = {
        let provider = MoyaProvider<KeyAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor()),
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
        return provider
    }()
}
