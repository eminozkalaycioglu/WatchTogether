//
//  LoginViewModel.swift
//  WatchTogether
//
//  Created by emin on 21.04.2021.
//

import Foundation


final class RegisterViewModel: BaseViewModel {
    
    private var firebaseMgr: FirebaseManager
    private var sessionMgr: SessionManager
    
    var onUserLoggedIn: (() -> Void)?
    
    init(firebaseMgr: FirebaseManager = WTFirebaseManager.shared,
         sessionMgr: SessionManager = WTSessionManager.shared) {
        self.firebaseMgr = firebaseMgr
        self.sessionMgr = sessionMgr
    }
    
    func register(_ request: RegisterRequestModel) {
        self.loadDidStart()
        self.firebaseMgr.register(request) { (result) in
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
