@_spi(HyphenInternal) import HyphenCore
import HyphenFlow
import HyphenNetwork
import SwiftUI

class HyphenKeyListState: ObservableObject {
    @Published var keys: [HyphenKey] = []

    @Published var isLoading: Bool = true

    @Published private var pendingRevokeKey: HyphenKey? = nil

    @Published var isShowRevokeKeyConfirmSheet: Bool = false

    init() {
        isLoading = true

        Task {
            let fetchKeysResult = try await HyphenNetworking.shared.getKeys()

            DispatchQueue.main.async {
                self.keys = fetchKeysResult
                self.isLoading = false
            }
        }
    }

    func pendingRevokeKey(_ key: HyphenKey?) {
        pendingRevokeKey = key
        isShowRevokeKeyConfirmSheet = key != nil
    }
}
