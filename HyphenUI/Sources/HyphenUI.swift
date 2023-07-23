import Foundation
import UIKit
import UserNotifications
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork

public extension Hyphen {
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        await handleNotification(userInfo: userInfo)
    }

    func handleNotificationWhenAppNotRunning(userInfo: [AnyHashable: Any]) async {
        await handleNotification(userInfo: userInfo)
    }

    private func handleNotification(userInfo: [AnyHashable: Any]) async {
        guard let hyphenNotificationType = userInfo["hyphen:type"] as? String else {
            return
        }

        guard let hyphenData = userInfo["hyphen:data"] as? String else {
            return
        }

        if hyphenNotificationType == "2fa-request" {
            try? await Task.sleep(nanoseconds: 1_000_000_000)

            guard let twoFactorRequest = try? JSONDecoder().decode(HyphenResponseSignIn2FA.self, from: hyphenData.data(using: .utf8)!) else {
                HyphenLogger.shared.logger.critical("HyphenUI SDK internal error. Push notification payload type is 2fa-request, but payload decode failed.")
                return
            }

            let vc = await Hyphen2FAViewController(twoFactorAuth: twoFactorRequest.twoFactorAuth)
            await MainActor.run {
                vc.isModalInPresentation = true
                vc.modalPresentationStyle = .fullScreen
            }
            await UIApplication.shared.hyphensdk_currentKeyWindow?.rootViewController?.present(vc, animated: true)
        }
    }
}
