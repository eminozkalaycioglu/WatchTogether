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
                
               
//                WTFirebaseManager.shared.fetchRoom(roomId: "F94EBF53-8B07-43F7-9366-4A7D3FD33B08") { (result) in
//                    switch result {
//                    case let .success(room):
//                        print(room.roomName)
//                    default: break
//                    }
//                }

//                WTFirebaseManager.shared.addContentToRoom(roomId: "A236CCE2-3215-422A-B38F-10D72F75E928", video: Video(videoId: "videoId", title: "Test Title", thumbnail: "https://wowmakers.com/blog/wp-content/uploads/2021/03/Video-thumbnail.jpeg", channel: "Channel Test", duration: 120)) { (_) in
//
//
//                }
                
//                WTFirebaseManager.shared.fetchRooms { (resuly) in
//                    switch resuly {
//                    case let .success(rooms):
//                        print("emintest: ", rooms.map({$0.content}))
//                    default: break
//                    }
//                }
////
//
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
