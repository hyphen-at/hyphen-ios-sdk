import HyphenAuthenticate
import HyphenCore
import HyphenUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Hyphen SDK Setup
        Hyphen.shared.appSecret = "lH2rU/P0gdv5+zJfgQzITluGHBNtX2jG1JiBZNbKHPQ"
        Hyphen.shared.network = .testnet

        HyphenAuthenticateAppDelegate.shared.application(application)
        HyphenUI.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        // Push notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    UNUserNotificationCenter.current().delegate = self
                    application.registerForRemoteNotifications()
                }
            }

            print("===== [HyphenSDKDemo] remote notification permission isGranted = \(granted)")
        }

        // Push notification when app is not running
        if let notificationInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            Task {
                await Hyphen.shared.handleNotificationWhenAppNotRunning(userInfo: notificationInfo)
            }
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        HyphenAuthenticateAppDelegate.shared.application(app, open: url, options: options)
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Hyphen.shared.apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async -> UIBackgroundFetchResult {
        await Hyphen.shared.application(application, didReceiveRemoteNotification: userInfo)

        return .newData
    }

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)

        return [[.alert, .sound, .badge, .list]]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        await Hyphen.shared.userNotificationCenter(center, didReceive: response)
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}
}
