//
//  CreateRoomViewModel.swift
//  WatchTogether
//
//  Created by emin on 25.04.2021.
//

import Foundation

final class CreateRoomViewModel: BaseViewModel {
    
    private var firebaseMgr: FirebaseManager
    private var sessionMgr: SessionManager

    var onRoomCreated: ((Room) -> Void)?
    
    init(firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         sessionMgr: SessionManager = WTSessionManager.shared) {
        self.firebaseMgr = firebaseMgr
        self.sessionMgr = sessionMgr
    }
    
    func createRoom(roomName: String, password: String?) {
        self.loadDidStart()
        guard let currentUser = self.sessionMgr.user else { return }
        self.firebaseMgr.createRoom(ownerUser: currentUser, roomName: roomName, password: password) { (result) in
            switch result {
            case let .success(room):
                self.loadDidFinish()
                self.onRoomCreated?(room)
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
}
