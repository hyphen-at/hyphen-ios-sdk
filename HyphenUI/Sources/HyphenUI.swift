import Foundation
import UIKit
import UserNotifications
@_spi(HyphenInternal) import HyphenCore

public extension Hyphen {
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        await handleNotification(userInfo: userInfo)
    }

    func handleNotificationWhenAppNotRunning(userInfo: [AnyHashable: Any]) async {
        await handleNotification(userInfo: userInfo)
    }

    private func handleNotification(userInfo: [AnyHashable: Any]) async {
        print(userInfo)

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let vc = await Hyphen2FAViewController()
        await MainActor.run {
            vc.isModalInPresentation = true
        }
        await UIApplication.shared.hyphensdk_currentKeyWindow?.rootViewController?.present(vc, animated: true)
    }
}
