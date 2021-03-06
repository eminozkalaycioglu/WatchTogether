//
//  AppDelegate.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

#if DEBUG && targetEnvironment(simulator)
import Bagel
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        WTAlert.setApperance()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = R.color.registerGreenColor()!
        
        #if DEBUG && targetEnvironment(simulator)
        Bagel.start()
        #endif
        
        if #available(iOS 13.0, *) {
            return true
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 14.0, *) { } else {
            window.tintColor = R.color.accentColor()!
        }
        
        AppRouter.configureWithWindow(window, initalViewController: SF.makeSplashVC())

        self.window = window
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

