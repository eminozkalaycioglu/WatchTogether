//
//  RoomViewModel.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import Foundation

final class RoomViewModel: BaseViewModel {
    
    var room: Room
    var users: [WTUser] = []
    
    private var firebaseMgr: FirebaseManager
    private var sessionMgr: SessionManager
    
    var onNewMessagesReceived: (() -> Void)?
    var onShouldBackToTabBar: (() -> Void)?
    var messages: [Message] = []
    
    init(room: Room,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         sessionMgr: SessionManager = WTSessionManager.shared) {
        self.room = room
        self.firebaseMgr = firebaseMgr
        self.sessionMgr = sessionMgr
       
    }
    
    func sendMessage(text: String) {
        guard let ownerId = self.sessionMgr.user?.userId,
              let roomId = self.room.roomId else { return }
        
        let now = DateFormatter.wtDateFormatter.string(from: Date())
        
        let message = Message(
            messageId: UUID().uuidString,
            text: text,
            ownerId: ownerId,
            sendTime: now)
        
        self.loadDidStart()
        self.firebaseMgr.addMessageToRoom(roomId: roomId, message: message) { (result) in
            switch result {
            case .success:
                self.loadDidFinish()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func observeMessages() {
        guard let roomId = self.room.roomId else { return }

        self.firebaseMgr.observeMessages(roomId: roomId) { (message) in
            self.messages.append(message)
            self.onNewMessagesReceived?()
        }
    }
    
    func observeRoomDeleting() {
        
        guard let uid = self.sessionMgr.user?.userId,
              let roomOwnerId = self.room.ownerId,
              uid != roomOwnerId else { return }
        
        self.firebaseMgr.observeRoomDeleting { (room) in
            if room?.roomId == self.room.roomId {
                self.onShouldBackToTabBar?()
            }
        }
    }
    
    func fetchUserInfos() {
        let ids = (self.room.users ?? []) + (self.room.oldUsers ?? [])
        self.loadDidStart()
        self.firebaseMgr.fetchRoomUserInfos(ids: ids) { (result) in
            switch result {
            case let .success(users):
                self.loadDidFinish()
                self.users = users
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func exitRoom(completion: @escaping (() -> Void)) {
        guard let uid = self.sessionMgr.user?.userId,
              let roomId = self.room.roomId,
              let roomOwnerId = self.room.ownerId else { return }
        
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
        self.users.filter({$0.userId == ownerId}).first?.avatarId ?? 1
    }
}

extension DateFormatter {
    static var wtDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df
    }
}
