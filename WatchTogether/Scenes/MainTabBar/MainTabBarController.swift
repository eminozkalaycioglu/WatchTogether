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
        
        let roomsVC = SF.makeRoomsVC().embedInWTNavVc()
        roomsVC.tabBarItem = UITabBarItem(title: "Odalar",
                                          image: R.image.roomsIcon()!,
                                          selectedImage: R.image.roomsIcon()!)
        
        
        let profileVC = SF.makeProfileVC().embedInWTNavVc()
        profileVC.tabBarItem = UITabBarItem(title: "Profil",
                                          image: R.image.profileIcon()!,
                                          selectedImage: R.image.profileIcon()!)
        
        let createRoomVC = SF.makeCreateRoomVC().embedInWTNavVc()
        createRoomVC.tabBarItem = UITabBarItem(title: "Oda Oluştur",
                                          image: R.image.createRoomIcon()!,
                                          selectedImage: R.image.createRoomIcon()!)
        
        self.setViewControllers([roomsVC, createRoomVC, profileVC], animated: true)
    }

}
