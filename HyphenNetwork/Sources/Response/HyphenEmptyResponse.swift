import Foundation

public protocol HyphenEmptyResponseProtocol {
    /// Empty value for the conforming type.
    ///
    /// - Returns: Value of `Self` to use for empty values.
    static func emptyValue() -> Self
}

/// Type representing an empty value. Use `Empty.value` to get the static instance.
public struct HyphenResponseEmpty: Codable {
    /// Static `Empty` instance used for all `Empty` responses.
    public static let value = HyphenResponseEmpty()
}

extension HyphenResponseEmpty: HyphenEmptyResponseProtocol {
    public static func emptyValue() -> HyphenResponseEmpty {
        value
    }
}
