//
//  AppDelegate.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import Firebase
import NMapsMap

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // for firebase
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // firebase init
        FirebaseApp.configure()
        
        // NaverMap clientID: q4essjxnxm
        // NaverMap clientSecret: 5KSGaiY0Tas1z9emWzpFzfptfrv7yVabfITVXSZI
        NMFAuthManager.shared().clientId = "q4essjxnxm"
        
        
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


}

