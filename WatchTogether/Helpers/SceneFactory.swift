//
//  SceneFactory.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit

final class SceneFactory {
    
    public static func makeViewController() -> TestViewController {
        let viewController = TestViewController()
        return viewController
    }
    
    public static func makeSplashVC() -> SplashViewController {
        let viewController = SplashViewController()
        let viewModel = SplashViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func makeLoginVC() -> LoginViewController {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func makeRoomsVC() -> RoomsViewController {
        let viewController = RoomsViewController()
        let viewModel = RoomsViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    
    public static func makeMainTabBar() -> MainTabBarController {
        let viewController = MainTabBarController()
        return viewController
    }
    
    
}

typealias SF = SceneFactory
