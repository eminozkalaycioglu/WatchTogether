//
//  ProfileViewModel.swift
//  WatchTogether
//
//  Created by emin on 25.04.2021.
//

import Foundation

final class ProfileViewModel: BaseViewModel {
    
    private var sessionMgr: SessionManager
    private var firebaseMgr: FirebaseManager
    private var uid: String?
    
    var onPasswordUpdated: (() -> Void)?
    var onLoggedOut: (() -> Void)?

    init(sessionMgr: SessionManager = WTSessionManager.shared,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared) {
        self.sessionMgr = sessionMgr
        self.firebaseMgr = firebaseMgr
        self.uid = sessionMgr.user?.userId
    }
    
    func getAvatarId() -> Int? {
        self.sessionMgr.user?.avatarId
    }
    
    func getEmail() -> String? {
        self.sessionMgr.user?.email
    }
    
    func getFullName() -> String? {
        self.sessionMgr.user?.fullName
    }
    
    func updateAvatar(newAvatarId: Int, completion: @escaping ((_ newAvatarId: Int) -> Void)) {
        self.loadDidStart()
        
        if let uid = self.uid {
            self.firebaseMgr.editAvatar(uid: uid, newAvatarId: newAvatarId) { (result) in
                switch result {
                case let .success(avatarId):
                    self.loadDidFinish()
                    self.sessionMgr.fetchUser {
                        completion(avatarId)
                    }
                case let .failure(error):
                    self.loadDidFinishWithError(error: error)
                }
            }
        }
    }
    
    func updatePassword(currentPassword: String ,newPassword: String) {
        self.loadDidStart()
        self.firebaseMgr.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { (result) in
            switch result {
            case .success:
                self.loadDidFinish()
                self.onPasswordUpdated?()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
    
    func logout() {
        self.loadDidStart()
        self.sessionMgr.logOut {
            self.loadDidFinish()
            self.onLoggedOut?()
        }
    }
}
