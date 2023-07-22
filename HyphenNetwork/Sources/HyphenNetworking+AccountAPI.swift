import Alamofire
import Foundation
import HyphenCore
import Moya

// MARK: - Hyphen Account API

public extension HyphenNetworking {
    func getMyAccount() async throws -> HyphenAccount {
        let result: HyphenResponseMyAccount = try await accountProvider.async.request(.getMyAccount)
        return result.account
    }
}
