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
    }
    
    private func setVCs() {
        
        let roomsVC = UINavigationController(rootViewController: SF.makeRoomsVC())
        roomsVC.tabBarItem = UITabBarItem(title: "Odalar",
                                          image: UIImage(),
                                          selectedImage: UIImage())
        
        self.setViewControllers([roomsVC], animated: true)
    }

}
