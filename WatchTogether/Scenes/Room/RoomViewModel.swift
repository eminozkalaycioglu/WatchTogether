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
    var totalUsers: [WTUser] = []
    var currentUsers: [WTUser] = []

    var messages: [Message] = []

    private var firebaseMgr: FirebaseManager
    private var sessionMgr: SessionManager
    private var youtubeService: YoutubeServicing
    
    var onNewMessagesReceived: (() -> Void)?
    var onFetchedUserInfos: (() -> Void)?
    var onShouldBackToTabBar: (() -> Void)?
    var onUsersChanged: (() -> Void)?

    init(roomId: String,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         sessionMgr: SessionManager = WTSessionManager.shared,
         youtubeService: YoutubeServicing = YoutubeServices()) {
        self.roomId = roomId
        self.firebaseMgr = firebaseMgr
        self.sessionMgr = sessionMgr
        self.youtubeService = youtubeService
    }
    
    func fetchRoom(completion: (() -> Void)? = nil) {
        self.loadDidStart()
        self.firebaseMgr.fetchRoom(roomId: self.roomId) { (result) in
            switch result {
            case let.success(room):
                self.loadDidFinish()
                if room.roomId != nil {
                    self.room = room
                    completion?()
                    self.fetchTotalUserInfos()
                }
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
            self.fetchRoom()
            self.onUsersChanged?()
        }
    }
    
    func removeRoomObservers() {
        self.firebaseMgr.removeRoomObservers()
    }
    
    private func fetchTotalUserInfos() {
        let userIDs = self.room?.users ?? []
        let oldUserIDs = self.room?.oldUsers ?? []
        
        if let uid = self.sessionMgr.user?.userId,
           !(userIDs.contains(uid)) {
            self.onShouldBackToTabBar?()
        }
                
        self.loadDidStart()
        self.firebaseMgr.fetchRoomUserInfos(ids: userIDs) { (result) in
            switch result {
            case let .success(currentUsers):
                self.currentUsers = currentUsers
                self.firebaseMgr.fetchRoomUserInfos(ids: oldUserIDs) { (result) in
                    switch result {
                    case let .success(oldUsers):
                        self.loadDidFinish()
                        self.totalUsers = currentUsers + oldUsers
                        self.onFetchedUserInfos?()
                    case let .failure(error):
                        self.loadDidFinishWithError(error: error)
                    }
                }
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
    
    var onShouldStartVideo: ((String) -> Void)?
    
    func addVideoToPlaylist(id: String) {
        guard self.currentUserIsOwner() else { return }
        self.youtubeService.getVideoDetail(id) { (result) in
            switch result {
            case let .success(videoDetail):
                let item = videoDetail.items.first
                let video = Video(
                    videoId: id,
                    title: item?.snippet.title,
                    thumbnail: item?.snippet.thumbnails.defaultField.url,
                    channel: item?.snippet.channelTitle,
                    sendTime: DateFormatter.wtDateFormatter.string(from: Date()))
                
                self.firebaseMgr.addVideoToRoomPlaylist(roomId: self.roomId, video: video) { (result) in
                    switch result {
                    case .success:
                        self.loadDidFinish()
                        self.fetchRoom {
                            if self.room?.content?.video?.title == nil {
                                self.firebaseMgr.addContentToRoom(roomId: self.roomId, video: video) { (_) in }
                            }
                            
                        }
                        
                    case let .failure(error):
                        self.loadDidFinishWithError(error: error)
                    }
                }
                
                
            case let.failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func addContentToRoom(video: Video) {
        self.firebaseMgr.addContentToRoom(roomId: self.roomId, video: video) { (_) in }
    }
    
    var onContentChanged: ((Content) -> Void)?
    
    func observeContent() {
        self.firebaseMgr.observeContent(roomId: self.roomId) { (result) in
            switch result {
            case let .success(content):
                self.onContentChanged?(content)
            case .failure: break
                
            }
        }
    }
    
    func manageNextVideo(completion: @escaping ((Video?) -> Void)) {
        guard self.currentUserIsOwner() else { return }
        self.firebaseMgr.fetchPlaylist(roomId: self.roomId) { (result) in
            switch result {
            case let .success(playlist):
                var sortedPlaylist = playlist
                sortedPlaylist.sort(by: { DateFormatter.wtDateFormatter.date(from: $0.sendTime ?? "") ?? Date() < DateFormatter.wtDateFormatter.date(from: $1.sendTime ?? "") ?? Date() })
                self.firebaseMgr.fetchContent(roomId: self.roomId) { (result) in
                    switch result {
                    case let .success(content):
                        let videoId = content.video?.videoId ?? ""
                        let currentIndex = sortedPlaylist.firstIndex(where: {$0.videoId == videoId}) ?? 0
                        if currentIndex + 1 == playlist.count {
                            completion(sortedPlaylist.first)
                        } else {
                            completion(sortedPlaylist[currentIndex + 1])
                        }
                    case .failure: break
                    }
                }
                
                
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func isMyMessage(_ message: Message) -> Bool {
        self.sessionMgr.user?.userId == message.ownerId
    }
    
    func getAvatarIdFrom(ownerId: String) -> Int {
        self.totalUsers.filter({$0.userId == ownerId}).first?.avatarId ?? 999
    }
    
    func getNameFrom(ownerId: String) -> String {
        String(self.totalUsers.filter({$0.userId == ownerId}).first?.fullName?.split(separator: " ").first ?? "")
    }
    
    func currentUserIsOwner() -> Bool {
        self.sessionMgr.user?.userId ?? "X" == self.room?.ownerId ?? "XX"
    }
    
    func getUserID() -> String {
        self.sessionMgr.user?.userId ?? ""
    }
}
