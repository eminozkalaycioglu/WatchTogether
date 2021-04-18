//
//  RoomsViewModel.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation

final class RoomsViewModel: BaseViewModel {
    
    var sessionMgr: SessionManager
    
    init(sessionMgr: SessionManager = WTSessionManager.shared) {
        self.sessionMgr = sessionMgr
    }
    
    func getUser() -> WTUser? {
        WTSessionManager.shared.user
    }
}
