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
    var onJoinedNewUser: (() -> Void)?
    var onShouldStartVideo: ((String) -> Void)?
    var onContentChanged: ((Content) -> Void)?
    var onVideoChanged: ((Video, Float) -> Void)?
    var onIsPlayingChanged: ((Bool) -> Void)?
    var onCurrentTimeChanged: ((Float) -> Void)?

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
        self.firebaseMgr.fetchRoom(roomId: self.roomId) { (result) in
            switch result {
            case let.success(room):
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
        
        self.firebaseMgr.addMessageToRoom(roomId: self.roomId, message: message) { (result) in
            switch result {
            case .success:
                self.loadDidFinish()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    private func fetchTotalUserInfos() {
        let userIDs = self.room?.users ?? []
        let oldUserIDs = self.room?.oldUsers ?? []
        
        if let uid = self.sessionMgr.user?.userId,
           !(userIDs.contains(uid)) {
            self.onShouldBackToTabBar?()
        }
                
        self.firebaseMgr.fetchRoomUserInfos(ids: userIDs) { (result) in
            switch result {
            case let .success(currentUsers):
                self.currentUsers = currentUsers
                self.firebaseMgr.fetchRoomUserInfos(ids: oldUserIDs) { (result) in
                    switch result {
                    case let .success(oldUsers):
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
        
    func addVideoToPlaylist(id: String) {
        guard self.currentUserIsOwner() else { return }
        self.youtubeService.getVideoDetail(id) { (result) in
            switch result {
            case let .success(videoDetail):
                let video = videoDetail.toVideo
                
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
        guard self.currentUserIsOwner() else { return }
        self.firebaseMgr.addContentToRoom(roomId: self.roomId, video: video) { (_) in
        }
    }
    
    func addContentToRoom(id: String) {
        guard self.currentUserIsOwner() else { return }
        self.youtubeService.getVideoDetail(id) { result in
            switch result {
            case let .success(videoDetail):
                self.addContentToRoom(video: videoDetail.toVideo)
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
                
            }
        }
    }
    
    func deleteVideoFromPlaylist(videoId: String) {
        guard self.currentUserIsOwner() else { return }
        self.loadDidStart()
        self.firebaseMgr.deleteVideoFromPlaylist(roomId: self.roomId, videoId: videoId) { result in
            switch result {
            case .success:
                self.loadDidFinish()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func setPlayingAndCurrentTime(status: Bool, second: Float) {
        guard self.currentUserIsOwner() else { return }
        self.firebaseMgr.setPlayingAndCurrentTime(roomId: self.roomId, state: status, second: second)
    }
    func setIsPlaying(_ status: Bool) {
        guard self.currentUserIsOwner() else { return }

        self.firebaseMgr.setPlaying(roomId: self.roomId, state: status)
    }
    
    func setCurrentTime(_ second: Float) {
        guard self.currentUserIsOwner() else { return }

        self.firebaseMgr.setCurrentTime(roomId: self.roomId, second: second)
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
    
    func autoSync() {
        guard !self.currentUserIsOwner() else { return }
        self.firebaseMgr.autoSync(roomId: self.roomId)
    }
    
}


//MARK: - Util Functions
extension RoomViewModel {
    
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


//MARK: - Observe Functions
extension RoomViewModel {
    
    func observeContent() {
        print("emintest observeContent ")
        self.firebaseMgr.observeContent(roomId: self.roomId) { [weak self] (result) in
            switch result {
            case let .success(content):
                self?.onContentChanged?(content)
            case .failure: break

            }
        }
    }
    
    func observeVideo() {
        self.firebaseMgr.observeContentVideo(roomId: self.roomId) { (video, currentTime) in
        
            self.onVideoChanged?(video, currentTime)
        }
    }
    
    func observeIsPlaying() {
        self.firebaseMgr.observeContentIsPlaying(roomId: self.roomId) { (isPlaying) in
            if let isPlaying = isPlaying {
                self.onIsPlayingChanged?(isPlaying)
            }
        }
        
    }
    
    func observeCurrentTime() {
        self.firebaseMgr.observeContentCurrentTime(roomId: self.roomId) { (currentTime) in
            if let currentTime = currentTime {
                self.onCurrentTimeChanged?(currentTime)
            }
            
        }
    }
    
    func observeMessages() {

        self.firebaseMgr.observeMessages(roomId: self.roomId) { [weak self] (message) in
            self?.messages.append(message)
            self?.onNewMessagesReceived?()
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
        self.firebaseMgr.observeRoomUsers(roomId: self.roomId) { [weak self] in
            self?.fetchRoom()
            self?.onUsersChanged?()
        }
    }
    
    func removeRoomObservers() {
        self.firebaseMgr.removeRoomObservers()
    }
    
    func observeAutoSync() {
        self.firebaseMgr.observeAutoSync(roomId: self.roomId) { [weak self] in
            self?.onJoinedNewUser?()
        }
    }
    
}
