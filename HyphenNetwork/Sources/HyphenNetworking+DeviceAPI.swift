import Alamofire
import Foundation
import HyphenCore
import Moya

// MARK: - Hyphen Device API

public extension HyphenNetworking {
    
    @discardableResult
    func editDevice(publicKey: String, payload: HyphenRequestEditDevice) async throws -> HyphenResponseEmpty {
        return try await deviceProvider.async.request(.editDevice(publicKey: publicKey, payload: payload))
    }

    @discardableResult
    func retry2FA(id: String, payload: HyphenRequestRetry2FA) async throws -> HyphenResponseEmpty {
        return try await deviceProvider.async.request(.retry2FA(id: id, payload: payload))
    }

    @discardableResult
    func deny2FA(id: String) async throws -> HyphenResponseEmpty {
        return try await deviceProvider.async.request(.deny2FA(id: id))
    }

    @discardableResult
    func approve2FA(id: String, payload: HyphenRequest2FAApprove) async throws -> HyphenResponseEmpty {
        return try await deviceProvider.async.request(.approve2FA(id: id, payload: payload))
    }
}
