//
//  SplashViewModel.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation

final class SplashViewModel: BaseViewModel {
    
    private var sessionMgr: SessionManager
    private var firebaseMgr: FirebaseManager
    init(sessionMgr: SessionManager = WTSessionManager.shared,
         firebaseMgr: FirebaseManager = WTFirebaseManager.shared) {
        self.sessionMgr = sessionMgr
        self.firebaseMgr = firebaseMgr
    }
    
    func prepare(completion: @escaping ((_ isLoggedIn: Bool) -> Void)) {
        if self.sessionMgr.isLoggedIn {
            self.sessionMgr.fetchUser {
                completion(true)
            }
        } else {
            completion(false)
        }
    }
}
