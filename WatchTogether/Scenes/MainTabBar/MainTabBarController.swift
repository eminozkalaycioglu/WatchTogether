//
//  MainTabBarController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setVCs()
        
        self.tabBar.barTintColor = R.color.tabBarTintColor()!
        self.tabBar.isTranslucent = false
    }
    
    private func setVCs() {
        
//        WTFirebaseManager.shared.fetchRooms { (result) in
//            switch result {
//            case .success(let room):
//                print("emintest: ",room.map({$0.users}))
//            default: break
//            }
//        }
        
        let roomsVC = SF.makeRoomsVC().embedInWTNavVc()
        roomsVC.tabBarItem = UITabBarItem(title: "Odalar",
                                          image: R.image.emailIcon()!,
                                          selectedImage: R.image.emailIcon()!)
        
        
        let profileVC = SF.makeProfileVC().embedInWTNavVc()
        profileVC.tabBarItem = UITabBarItem(title: "Profil",
                                          image: R.image.passwordIcon()!,
                                          selectedImage: R.image.passwordIcon()!)
        
        let createRoomVC = SF.makeCreateRoomVC().embedInWTNavVc()
        createRoomVC.tabBarItem = UITabBarItem(title: "Profil",
                                          image: R.image.passwordIcon()!,
                                          selectedImage: R.image.passwordIcon()!)
        
        self.setViewControllers([roomsVC, profileVC, createRoomVC], animated: true)
    }

}
