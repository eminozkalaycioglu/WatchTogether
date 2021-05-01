//
//  RoomViewModel.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import Foundation

final class RoomViewModel: BaseViewModel {
    
    var roomId: String
    var room: Room?
    var users: [WTUser] = []
    var messages: [Message] = []

    private var firebaseMgr: FirebaseManager
    private var sessionMgr: SessionManager
    
    var onNewMessagesReceived: (() -> Void)?
    var onFetchedUserInfos: (() -> Void)?
    var onShouldBackToTabBar: (() -> Void)?
    
    init(roomId: String,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         sessionMgr: SessionManager = WTSessionManager.shared) {
        self.roomId = roomId
        self.firebaseMgr = firebaseMgr
        self.sessionMgr = sessionMgr
        
    }
    
    func fetchRoom() {
        self.loadDidStart()
        self.firebaseMgr.fetchRoom(roomId: self.roomId) { (result) in
            switch result {
            case let.success(room):
                self.loadDidFinish()
                if room.roomId != nil {
                    self.room = room
                }
                
                self.fetchUserInfos()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func sendMessage(text: String) {
        guard let ownerId = self.sessionMgr.user?.userId else { return }
        
        let now = DateFormatter.wtDateFormatter.string(from: Date())
        
        let message = Message(
            messageId: UUID().uuidString,
            text: text,
            ownerId: ownerId,
            sendTime: now)
        
        self.loadDidStart()
        self.firebaseMgr.addMessageToRoom(roomId: self.roomId, message: message) { (result) in
            switch result {
            case .success:
                self.loadDidFinish()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func observeMessages() {

        self.firebaseMgr.observeMessages(roomId: self.roomId) { (message) in
            self.messages.append(message)
            self.onNewMessagesReceived?()
        }
    }
    
    func observeRoomDeleting() {
        
//        guard let uid = self.sessionMgr.user?.userId,
//              let roomOwnerId = self.room.ownerId,
//              uid != roomOwnerId else { return }
        
        self.firebaseMgr.observeRoomDeleting { [weak self] (room) in

            if room?.roomId == self?.roomId {
                self?.onShouldBackToTabBar?()
            }
        }
    }
    
    func observeRoomUsers() {
        self.firebaseMgr.observeRoomUsers(roomId: self.roomId) {
            print("observe action")
            self.fetchRoom()
        }
    }
    
    func removeRoomObservers() {
        self.firebaseMgr.removeRoomObservers()
    }
    
    private func fetchUserInfos() {
        let ids = (self.room?.users ?? []) + (self.room?.oldUsers ?? [])
        self.loadDidStart()
        self.firebaseMgr.fetchRoomUserInfos(ids: ids) { (result) in
            switch result {
            case let .success(users):
                self.loadDidFinish()
                self.users = users
                self.onFetchedUserInfos?()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func exitRoom(completion: @escaping (() -> Void)) {
        guard let uid = self.sessionMgr.user?.userId,
              let roomId = self.room?.roomId,
              let roomOwnerId = self.room?.ownerId else { return }
        
        if roomOwnerId == uid {
            self.loadDidStart()
            self.firebaseMgr.deleteRoom(roomId: roomId) { (result) in
                switch result {
                case .success:
                    self.loadDidFinish()
                    completion()
                case let .failure(error):
                    self.loadDidFinishWithError(error: error)
                }
            }
        } else {
            self.loadDidStart()
            self.firebaseMgr.exitRoom(uid: uid, roomId: roomId) { (result) in
                switch result {
                case .success:
                    self.loadDidFinish()
                    completion()
                case let .failure(error):
                    self.loadDidFinishWithError(error: error)
                }
            }
        }
    }
    
    func isMyMessage(_ message: Message) -> Bool {
        self.sessionMgr.user?.userId == message.ownerId
    }
    
    func getAvatarIdFrom(ownerId: String) -> Int {
        self.users.filter({$0.userId == ownerId}).first?.avatarId ?? 999
    }
}

extension DateFormatter {
    static var wtDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df
    }
}

