@_spi(HyphenInternal) import HyphenCore
import HyphenFlow
import HyphenNetwork
import SwiftUI

class HyphenKeyListState: ObservableObject {
    @Published var keys: [HyphenKey] = []

    init() {
        Task {
            keys = try await HyphenNetworking.shared.getKeys()
        }
    }
}
