import Foundation
import Moya

@_spi(HyphenInternal)
public enum SignAPI {
    case signTransactionWithServerKey(message: String)
    case signTransactionWithPayMasterKey(message: String)
}
