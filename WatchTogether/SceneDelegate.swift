//
//  SceneDelegate.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)

        AppRouter.configureWithWindow(window, initalViewController: SF.makeSplashVC())
        
//        AppRouter.configureWithWindow(window, initalViewController: TestViewController())

        if #available(iOS 14.0, *) { } else {
            window.tintColor = R.color.accentColor()!
        }
        
        self.window = window
                
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

