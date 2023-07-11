import Foundation
import UIKit

@_spi(HyphenInternal)
public extension UIApplication {
    var hyphensdk_currentKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)
    }
}

@_spi(HyphenInternal)
public extension UIApplication {
    var hyphensdk_currentKeyWindowPresentedController: UIViewController? {
        var viewController = hyphensdk_currentKeyWindow?.rootViewController

        if let presentedController = viewController as? UITabBarController {
            viewController = presentedController.selectedViewController
        }

        while let presentedController = viewController?.presentedViewController {
            if let presentedController = presentedController as? UITabBarController {
                viewController = presentedController.selectedViewController
            } else {
                viewController = presentedController
            }
        }

        return viewController
    }
}
