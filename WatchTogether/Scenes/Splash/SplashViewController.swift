//
//  SplashViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit

class SplashViewController: WTViewController {

    var viewModel: SplashViewModel!
    
    override func setup() {
        super.setup()
        
        self.viewModel.prepare { (isLoggedIn) in
            if isLoggedIn {
                self.router.setRootViewController(SF.makeMainTabBar())
            } else {
                self.router.setRootViewController(SF.makeLoginVC())
            }
        }
        
    }
    

}
