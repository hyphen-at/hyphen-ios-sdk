import Foundation
import UIKit
import UserNotifications
@_spi(HyphenInternal) import HyphenCore
import HyphenNetwork
import RealEventsBus

public extension Hyphen {
    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async {
        await handleNotification(userInfo: userInfo)
    }

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
        } else if hyphenNotificationType == "2fa-status-change" {
            guard let twoFactorRequest = try? JSONDecoder().decode(HyphenResponseSignIn2FA.self, from: hyphenData.data(using: .utf8)!) else {
                HyphenLogger.shared.logger.critical("HyphenUI SDK internal error. Push notification payload type is 2fa-request-change, but payload decode failed.")
                return
            }
            
            switch twoFactorRequest.twoFactorAuth.status {
            case .denied:
                Bus<HyphenEventBusType>.post(.show2FAWaitingProgressModal(isShow: false))
                let alertController = await UIAlertController(title: "Login Failed", message: "2FA Request denied from your another device.", preferredStyle: .alert)

                let OKAction = await UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction!) in
                    Task {
                        await MainActor.run {
                            alertController.dismiss(animated: false)
                        }
                    }
                }

                await alertController.addAction(OKAction)
                await UIApplication.shared.hyphensdk_currentKeyWindow?.rootViewController?.present(alertController, animated: true)

                Bus<HyphenEventBusType>.post(.twoFactorAuthDenied)
            case .approved:
                Bus<HyphenEventBusType>.post(.twoFactorAuthApproved(requestId: twoFactorRequest.twoFactorAuth.request.id))
            default:
                break
            }
        }
    }
}

public final class HyphenUI: NSObject {
    public static let shared: HyphenUI = .init()

    override private init() {
        super.init()

        var loadingIndicator: HyphenTopLoadingIndicator? = nil

        Bus<HyphenEventBusType>.register(self) { event in
            switch event {
            case let .show2FAWaitingProgressModal(isShow: isShow):
                if isShow {
                    loadingIndicator = HyphenTopLoadingIndicator(text: "Waiting 2FA approval...")
                    UIApplication.shared.hyphensdk_currentKeyWindowPresentedController?.view.addSubview(loadingIndicator!)
                } else {
                    loadingIndicator?.removeFromSuperview()
                    loadingIndicator = nil
                }
            default:
                break
            }
        }
    }

    deinit {
        Bus<HyphenEventBusType>.unregister(self)
    }

    public func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) {}
}
