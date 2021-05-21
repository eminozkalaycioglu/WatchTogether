//
//  PlaylistViewModel.swift
//  WatchTogether
//
//  Created by emin on 21.05.2021.
//

import Foundation

final class PlaylistViewModel: BaseViewModel {
    private var firebaseMgr: FirebaseManager
    private var roomId: String
    
    var onFetchedPlaylist: (() -> Void)?
    var playlist: [Video] = []
    
    init(firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         roomId: String) {
        self.firebaseMgr = firebaseMgr
        self.roomId = roomId
    }
    
    func observePlaylist() {
        self.firebaseMgr.observePlaylist(roomId: self.roomId) { [weak self] in
            self?.getPlaylist()
        }
    }
    
    func getPlaylist() {
        self.loadDidStart()
        self.firebaseMgr.fetchPlaylist(roomId: roomId) { (result) in
            switch result {
            case let .success(playlist):
                self.loadDidFinish()
                self.playlist = playlist.sorted(by: { DateFormatter.wtDateFormatter.date(from: $0.sendTime ?? "") ?? Date() < DateFormatter.wtDateFormatter.date(from: $1.sendTime ?? "") ?? Date() })
               
                self.onFetchedPlaylist?()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
}
