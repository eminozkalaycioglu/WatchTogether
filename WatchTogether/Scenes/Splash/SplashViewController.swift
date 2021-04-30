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
                
//                WTFirebaseManager.shared.joinRoom(user: WTSessionManager.shared.user!, roomId: "f6ae6beb-2bff-4708-9be9-b19af24f4fe1", password: nil) { (result) in
//                    switch result {
//                    case let .success(room):
//                        self.router.setRootViewController(SF.makeRoomVC(room: room).embedInWTNavVc())
//                    case .failure:
//                        break
//
//                    }
//                }
//                
//                WTFirebaseManager.shared.observeRoomDeleting { (room) in
//                    print("deleting: \(room?.roomId)")
//                }
            } else {
                self.router.setRootViewController(SF.makeLoginVC())
            }
        }
        
    }
    

}
