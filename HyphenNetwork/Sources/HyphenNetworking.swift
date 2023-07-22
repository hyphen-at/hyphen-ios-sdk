import Foundation
import HyphenCore
import Moya

public final class HyphenNetworking: NSObject {
    public static let shared: HyphenNetworking = .init()

    override private init() {}

    @_spi(HyphenInternal)
    public lazy var authProvider: MoyaProvider<AuthAPI> = {
        let provider = MoyaProvider<AuthAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor())
        )
        return provider
    }()

    @_spi(HyphenInternal)
    public lazy var deviceProvider: MoyaProvider<DeviceAPI> = {
        let provider = MoyaProvider<DeviceAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor())
        )
        return provider
    }()

    @_spi(HyphenInternal)
    public lazy var signProvider: MoyaProvider<SignAPI> = {
        let provider = MoyaProvider<SignAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor())
        )
        return provider
    }()

    @_spi(HyphenInternal)
    public lazy var accountProvider: MoyaProvider<AccountAPI> = {
        let provider = MoyaProvider<AccountAPI>(
            session: Session(interceptor: HyphenHeaderInterceptor())
        )
        return provider
    }()
}
