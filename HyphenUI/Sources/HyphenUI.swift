import Foundation
import UIKit
import UserNotifications
@_spi(HyphenInternal) import HyphenCore

public extension Hyphen {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await UIApplication.shared.hyphensdk_currentKeyWindow?.rootViewController?.present(Hyphen2FAViewController(), animated: true)
    }
}
