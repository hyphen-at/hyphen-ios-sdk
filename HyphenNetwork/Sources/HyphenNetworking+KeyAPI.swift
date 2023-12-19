import Alamofire
import Foundation
import HyphenCore
import Moya

// MARK: - Hyphen Key API

public extension HyphenNetworking {
    func getKeys() async throws -> [HyphenKey] {
        let result: HyphenResponseKeys = try await keyProvider.async.request(.getKeys)
        return result.keys
    }

    func deleteKey(_ key: String) async throws {
        let _: Empty = try await keyProvider.async.request(.deletePublicKey(key))
    }
}
