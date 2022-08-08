//
//  AppDelegate.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/04.
//

import UIKit
import FirebaseCore
import GoogleMobileAds
import FirebaseAppCheck
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initializeFirebase()
        initilizeAdmob()
        
        return true
    }
    private func initilizeAppCheck() {
        let providerFactory = CookieAppCheckProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
    }
    
    private func initilizeAdmob() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    private func initializeFirebase() {
        initilizeAppCheck()
        FirebaseApp.configure()
        Auth.auth().signInAnonymously()
    }
}
