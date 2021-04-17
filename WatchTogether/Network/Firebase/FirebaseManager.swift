//
//  FirebaseManager.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import Foundation
import Firebase

final class FirebaseManager {
    
    private init() { }
    
    static let shared = FirebaseManager()
    private var dbRef: DatabaseReference = Database.database().reference()
    
    private func saveUserInfo(_ request: RegisterRequestModel, uid: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        
        var dict: [String: Any] = [:]
        dict["userId"] = uid
        dict["avatarId"] = request.avatarId
        dict["fullName"] = request.fullName
        dict["email"] = request.email
        dict["birthdate"] = request.birthdate
        
        self.dbRef.child("Users").child(uid).setValue(dict) { (error, _) in
            if let error = error {
                completion(.failure(PresentableError(message: error.localizedDescription)))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func register(_ request: RegisterRequestModel, completion: @escaping ((Result<WTUser, PresentableError>)->Void)) {
        
        Auth.auth().createUser(withEmail: request.email, password: request.password) { (firResult, firError) in
            
            if let firError = firError {
                completion(.failure(firError.presentableError))
                return
            } else if let firResult = firResult {
                
                self.saveUserInfo(request, uid: firResult.user.uid) { (result) in
                    switch result {
                    case .success:
                        let user = WTUser(
                            userId: firResult.user.uid,
                            avatarId: request.avatarId,
                            fullName: request.fullName,
                            email: request.email,
                            birthdate: request.birthdate)
                        completion(.success(user))
                    case let .failure(presentableError):
                        completion(.failure(presentableError))
                    }
                }
                
            }
        }
    }
    
    func fetchUserInfo(uid: String, completion: @escaping ((Result<WTUser, PresentableError>)->Void)) {
        self.dbRef.child("Users").child(uid).observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.init(message: "Parse Error")))
                return
            }
            
            let userId = value["userId"] as? String
            let avatarId = value["avatarId"] as? Int
            let fullName = value["fullName"] as? String
            let email = value["email"] as? String
            let birthdate = value["birthdate"] as? String
            
            let user = WTUser(
                userId: userId,
                avatarId: avatarId,
                fullName: fullName,
                email: email,
                birthdate: birthdate)
            
            completion(.success(user))
            
        }
        
    }
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func getCurrentAuthUser() -> User? {
        Auth.auth().currentUser
    }
    
    func createRoom(ownerUser: WTUser, roomName: String, password: String?, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        
        var dict: [String: Any] = [:]
        let roomId = UUID().uuidString
        dict["roomId"] = roomId
        dict["password"] = password
        dict["roomName"] = roomName
        dict["ownerId"] = ownerUser.userId
        
        let roomRef = self.dbRef.child("Rooms").child(roomId)
        roomRef.setValue(dict) { (error, _) in
            if let error = error {
                completion(.failure(PresentableError(message: error.localizedDescription)))
                return
            } else {
                self.addUserToRoom(roomId: roomId, user: ownerUser, completion: completion)
            }
        }
        
    }

    private func addUserToRoom(roomId: String, user: WTUser, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Users").child(user.userId ?? "").setValue(user.toDict()) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }

    }
    
    func joinRoom(user: WTUser, roomId: String, password: String?, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.init(message: "Parse Error")))
                return
            }
            
            if let password = value["password"] as? String, password != password {
                completion(.failure(.init(message: "Wrong Password")))
            } else {
                self.addUserToRoom(roomId: roomId, user: user) { (result) in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
            
        }
        
    }
    
    func fetchRoom(roomId: String, completion: @escaping ((Result<Room, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.init(message: "Parse Error")))
                return
            }
            
            var users: [WTUser] = []
            for child in (snapshot.childSnapshot(forPath: "Users").children.allObjects as! [DataSnapshot]) {
                let value = child.value as? NSDictionary
                let avatarId = value?.value(forKey: "avatarId") as? Int
                let birthdate = value?.value(forKey: "birthdate") as? String
                let email = value?.value(forKey: "email") as? String
                let fullName = value?.value(forKey: "fullName") as? String
                let userId = value?.value(forKey: "userId") as? String
                
                users.append(WTUser(userId: userId, avatarId: avatarId, fullName: fullName, email: email, birthdate: birthdate))
            }
            print()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let value = child.value as? NSDictionary
                

            }
        }
        
       
    }
    
}

struct Room {
    var roomId: String?
    var password: String?
    var roomName: String?
    var ownerId: String?
    var content: Content?
    var playlist: [Video]?
    var users: [WTUser]?
    var message: [Message]?
}

struct Video {
    var videoId: String?
    var title: String?
    var thumbnail: String?
    var channel: String?
    var duration: Int?
}

struct Content {
    var videos: [Video]?
    var currentTime: Int?
    var isPlaying: Bool?
}

struct Message {
    var messageId: String?
    var text: String?
    var ownerId: String?
    var sendTime: String?
}
