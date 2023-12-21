import Alamofire
import Foundation
import HyphenCore
import Moya

// MARK: - Hyphen Signing API

public extension HyphenNetworking {
    func getPayerAddress() async throws -> (String, Int) {
        let result: HyphenResponseCadence = try await signProvider.async.request(.getPayerAddress)
        return (result.payerAddress, result.payerKeyIndex)
    }

    func signTransactionWithServerKey(message: String) async throws -> HyphenSignResult {
        try await signProvider.async.request(.signTransactionWithServerKey(message: message))
    }

    func signTransactionWithPayMasterKey(message: String) async throws -> HyphenSignResult {
        try await signProvider.async.request(.signTransactionWithPayMasterKey(message: message))
    }
}
