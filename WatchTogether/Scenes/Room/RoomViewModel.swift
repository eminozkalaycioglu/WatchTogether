//
//  RoomViewModel.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import Foundation

final class RoomViewModel: BaseViewModel {
    
    var room: Room
    
    private var firebaseMgr: FirebaseManager
    private var sessionMgr: SessionManager
    
    var onNewMessagesReceived: (() -> Void)?
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
}

extension DateFormatter {
    static var wtDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df
    }
}
