//
//  AppDelegate.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import Firebase
import NMapsMap
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    // for firebase
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        checkInternetConnected()
        
        
        
        // firebase init
        FirebaseApp.configure()
        
        // NaverMap clientID: q4essjxnxm
        // NaverMap clientSecret: 5KSGaiY0Tas1z9emWzpFzfptfrv7yVabfITVXSZI
        NMFAuthManager.shared().clientId = "q4essjxnxm"
        
        if #available(iOS 10.0, *) {
            //FOR iOS notification display (sent vi APNS)
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings = UIUserNotificationSettings(types:[.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Getting Messaing Token
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - 화면 세로로 고정시키기.(가로전환 막기)
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: - 인터넷 연결 체크
    func checkInternetConnected() {
        Reachability.isConnectedToNetwork { (isConnected) in
            if isConnected == false {
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
        
    
}

// messaging
extension AppDelegate {
    func messaging(_ messaging: Messaging, didReciveRegistrationToken fcmToken: String?) {
        print("Firebase reg token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

