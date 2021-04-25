//
//  LoginViewModel.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation

final class LoginViewModel: BaseViewModel {
    
    var firebaseMgr: FirebaseManager
    var sessionMgr: SessionManager
    
    var onUserLoggedIn: (() -> Void)?
    
    init(firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         sessionMgr: SessionManager = WTSessionManager.shared) {
        self.firebaseMgr = firebaseMgr
        self.sessionMgr = sessionMgr
    }
    
    func login(email: String, password: String) {
        self.loadDidStart()
        self.firebaseMgr.login(email: email, password: password) { (result) in
            switch result {
            case let .success(user):
                self.loadDidFinish()
                self.sessionMgr.loggedIn(user: user)
                self.onUserLoggedIn?()
            case let .failure(error):
                self.loadDidFinishWithError(error: error)
            }
        }
    }
}
