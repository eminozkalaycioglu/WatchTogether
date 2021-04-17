//
//  WTUser.swift
//  WatchTogether
//
//  Created by emin on 12.04.2021.
//

import Foundation

struct WTUser {
    
    let userId: String?
    let avatarId: Int?
    let fullName: String?
    let email: String?
    let birthdate: String?
    
    func toDict() -> [String: Any] {
        return [
            "userId": self.userId,
            "avatarId": self.avatarId,
            "fullName": self.fullName,
            "email": self.email,
            "birthdate": self.birthdate
        ]
        
    }
}
