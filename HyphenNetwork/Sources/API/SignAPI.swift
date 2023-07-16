import Foundation
import Moya

public enum SignAPI {
    case signTransactionWithServerKey(message: String)
    case signTransactionWithPayMasterKey(message: String)
}
