//
//  RoomsViewModel.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation

final class RoomsViewModel: BaseViewModel {
    
    private var sessionMgr: SessionManager
    private var firebaseMgr: FirebaseManager
    
    var onFetchedRooms: (() -> Void)?
    var onJoinedRoom: ((String?) -> Void)?

    var rooms: [Room] = []
    
    init(sessionMgr: SessionManager = WTSessionManager.shared,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared) {
        self.sessionMgr = sessionMgr
        self.firebaseMgr = firebaseMgr
    }
    
    func getUser() -> WTUser? {
        WTSessionManager.shared.user
    }
    
    func fetchRooms() {
        self.loadDidStart()
        self.firebaseMgr.fetchRooms { (result) in
            switch result {
            case let .success(rooms):
                self.rooms = rooms
                self.onFetchedRooms?()
                self.loadDidFinish()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func joinRoom(index: Int) {
        guard let roomId = self.rooms[index].roomId,
              let user = self.getUser() else { return }
        self.loadDidStart()
        self.firebaseMgr.joinRoom(user: user, roomId: roomId, password: nil) { (result) in
            switch result {
            case let .success(room):
                self.loadDidFinish()
                self.onJoinedRoom?(room.roomId)
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func observeRooms() {
        self.firebaseMgr.observeRoomAdding { [weak self] (_) in
            self?.fetchRooms()
        }
        
        self.firebaseMgr.observeRoomDeleting { [weak self] (_) in
            self?.fetchRooms()
        }
    }
    
    func removeRoomObservers() {
        self.firebaseMgr.removeRoomObservers()
    }
}
