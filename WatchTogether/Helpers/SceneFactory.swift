//
//  SceneFactory.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit
import EachNavigationBar
extension UIViewController {
    func embedInWTNavVc() -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: self)
        nav.navigation.configuration.isEnabled = true
        nav.navigation.configuration.barTintColor = R.color.mainBlueColorLight()!
        nav.navigation.configuration.statusBarStyle = .lightContent
        nav.navigation.configuration.backItem = .init(style: .image(R.image.backIcon()!))
        return nav
    }
}

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
    
    public static func makeLoginVC() -> UINavigationController {
        let viewController = LoginViewController()
        let viewModel = LoginViewModel()
        viewController.viewModel = viewModel
        return viewController.embedInWTNavVc()
    }
    
    public static func makeRegisterVC() -> RegisterViewController {
        let viewController = RegisterViewController()
        let viewModel = RegisterViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func makeRoomsVC() -> RoomsViewController {
        let viewController = RoomsViewController()
        let viewModel = RoomsViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func makeEnterPasswordVC(index: Int) -> EnterPasswordViewController {
        let viewController = EnterPasswordViewController()
        viewController.selectedIndex = index
        return viewController
    }
    
    public static func makeRoomVC(roomId: String) -> RoomViewController {
        let viewController = RoomViewController()
        let viewModel = RoomViewModel(roomId: roomId)
        viewController.viewModel = viewModel
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
    
    public static func makeUsersVC(users: [WTUser], roomId: String, userId: String, canDelete: Bool) -> UsersViewController {
        let viewController = UsersViewController()
        
        let viewModel = UsersViewModel(
            users: users,
            roomId: roomId,
            userId: userId,
            canDelete: canDelete)
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    public static func makePlaylistVC(roomId: String, canOpenWebView: Bool) -> PlaylistViewController {
        let viewController = PlaylistViewController()
        let viewModel = PlaylistViewModel(roomId: roomId)
        viewController.viewModel = viewModel
        viewController.canOpenWebView = canOpenWebView
        return viewController
    }
    
    public static func makeCreateRoomVC() -> CreateRoomViewController {
        let viewController = CreateRoomViewController()
        let viewModel = CreateRoomViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    
    public static func makeProfileVC() -> ProfileViewController {
        let viewController = ProfileViewController()
        let viewModel = ProfileViewModel()
        viewController.viewModel = viewModel
        return viewController
    }
    
    
    public static func makeMainTabBar() -> MainTabBarController {
        let viewController = MainTabBarController()
        return viewController
    }
    
    
}

typealias SF = SceneFactory
