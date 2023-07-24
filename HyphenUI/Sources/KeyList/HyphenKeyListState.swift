@_spi(HyphenInternal) import HyphenCore
import HyphenFlow
import HyphenNetwork
import SwiftUI

class HyphenKeyListState: ObservableObject {
    @Published var keys: [HyphenKey] = []

    @Published var isLoading: Bool = true

    init() {
        isLoading = true

        Task {
            keys = try await HyphenNetworking.shared.getKeys()
            isLoading = false
        }
    }
}
