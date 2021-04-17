//
//  WTSessionManager.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import Foundation

protocol SessionManager {
    var user: WTUser? { get set }
    var isLoggedIn: Bool { get }
    
    func loggedIn(user: WTUser)
    func logOut(completion: ()->Void)
    func fetchUser(_ completion: @escaping ()->Void)
}

final class WTSessionManager: SessionManager {
    
    static let shared = WTSessionManager()
    
    let firebaseMgr = FirebaseManager.shared
        
    var user: WTUser?
    
    var isLoggedIn: Bool {
        self.firebaseMgr.getCurrentAuthUser() != nil
    }
        
    func loggedIn(user: WTUser) {
        self.user = user
    }
    
    func logOut(completion: () -> Void) {
        if self.firebaseMgr.signOut() {
            self.user = nil
            completion()
        }
    }
    
    
    func fetchUser(_ completion: @escaping ()->Void) {
        guard let currentUser = self.firebaseMgr.getCurrentAuthUser() else { return }
        
        self.firebaseMgr.fetchUserInfo(uid: currentUser.uid) { (result) in
            switch result {
            case let .success(user):
                self.loggedIn(user: user)
                completion()
            case .failure: break
            }
        }
    }
    
    private init() { }
}
