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
                                          image: R.image.emailIcon()!,
                                          selectedImage: R.image.emailIcon()!)
        
        
        let profileVC = SF.makeProfileVC().embedInWTNavVc()
        profileVC.tabBarItem = UITabBarItem(title: "Profil",
                                          image: R.image.passwordIcon()!,
                                          selectedImage: R.image.passwordIcon()!)
        
        self.setViewControllers([roomsVC, profileVC], animated: true)
    }

}
