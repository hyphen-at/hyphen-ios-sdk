import Foundation
@_spi(HyphenInternal) import HyphenCore
import Moya
import UIKit

final class HyphenHeaderInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let mutableUrlRequest = ((urlRequest as NSURLRequest).mutableCopy() as? NSMutableURLRequest)!
        mutableUrlRequest.setValue(Hyphen.shared.appSecret, forHTTPHeaderField: "X-Hyphen-App-Secret")
        mutableUrlRequest.setValue("iOS", forHTTPHeaderField: "X-Hyphen-SDK-Platform")
        mutableUrlRequest.setValue("0.1.0", forHTTPHeaderField: "X-Hyphen-SDK-Version")

        if Hyphen.shared.isCredentialExist() {
            let credential = Hyphen.shared.getCredential()
            mutableUrlRequest.setValue("Bearer \(credential.accessToken)", forHTTPHeaderField: "Authorization")
        }

        let editedUrlRequest = mutableUrlRequest as URLRequest
        completion(.success(editedUrlRequest))
    }
}
