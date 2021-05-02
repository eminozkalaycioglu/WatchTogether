//
//  UsersViewModel.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Foundation

final class UsersViewModel: BaseViewModel {
    
    private let firebaseMgr: FirebaseManager
    private var roomId: String
    var userId: String
    var canDelete: Bool
    var users: [WTUser]
    
    var onUserDeleted: (() -> Void)?

    init(users: [WTUser],
         roomId: String,
         userId: String,
         canDelete: Bool,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared) {
        self.firebaseMgr = firebaseMgr
        self.users = users
        self.roomId = roomId
        self.canDelete = canDelete
        self.userId = userId
    }
    
    func deleteUser(uid: String) {
        self.loadDidStart()
        self.firebaseMgr.exitRoom(uid: uid, roomId: self.roomId) { (result) in
            switch result {
            case .success:
                self.loadDidFinish()
                self.onUserDeleted?()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
}
