import Alamofire
import Foundation
import HyphenCore
import Moya

// MARK: - Hyphen Signing API

public extension HyphenNetworking {
    func signTransactionWithServerKey(message: String) async throws -> HyphenSignResult {
        return try await signProvider.async.request(.signTransactionWithServerKey(message: message))
    }

    func signTransactionWithPayMasterKey(message: String) async throws -> HyphenSignResult {
        return try await signProvider.async.request(.signTransactionWithPayMasterKey(message: message))
    }
}
