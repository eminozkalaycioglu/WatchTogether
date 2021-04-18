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
    
}


//MARK: - Room Functions
extension FirebaseManager {
    
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

    func joinRoom(user: WTUser, roomId: String, password: String?, completion: @escaping ((Result<Room, PresentableError>) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).observe(.value) { (snapshot) in
            
            guard let room = self.fetchRoomFrom(snapshot: snapshot) else {
                completion(.failure(.init(message: "Parse Error")))
                return
            }
            
            if let password = room.password, password != password {
                completion(.failure(.init(message: "Wrong Password")))
            } else {
                self.addUserToRoom(roomId: roomId, user: user) { (result) in
                    switch result {
                    case .success:
                        completion(.success(room))
                        break
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            }
            
        }
        
    }
    
    func fetchRooms(completion: @escaping ((Result<[Room], PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.init(message: "Parse Error")))
                return
            }
            
            var rooms: [Room] = []
            
            for roomId in value.keys {
                if let room = self.fetchRoomFrom(snapshot: snapshot.childSnapshot(forPath: roomId)) {
                    rooms.append(room)
                }
            }
            
            completion(.success(rooms))

        }
    }
    
    func addVideoToRoomPlaylist(roomId: String, video: Video, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child(roomId).child("Playlist").childByAutoId().setValue(video.toDict()) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func addUserToRoom(roomId: String, user: WTUser, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Users").child(user.userId ?? "").setValue(user.toDict()) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }

    }
    
    func addMessageToRoom(roomId: String, message: Message, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Messages").childByAutoId().setValue(message.toDict()) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }

    }
    
    func observeMessages(roomId: String, completion: @escaping (([Message]) -> Void)) {
        
        var messages: [Message] = []
        self.dbRef.child("Rooms").child(roomId).child("Messages").observe(.childAdded) { (snapshot) in
            
            for child in (snapshot.children.allObjects as! [DataSnapshot]) {
                let value = child.value as? NSDictionary
                let messageId = value?.value(forKey: "messageId") as? String
                let text = value?.value(forKey: "text") as? String
                let ownerId = value?.value(forKey: "ownerId") as? String
                let sendTime = value?.value(forKey: "sendTime") as? String
                messages.append(Message(messageId: messageId, text: text, ownerId: ownerId, sendTime: sendTime))
            }
            
            completion(messages)
        }
    }
    
}


//MARK: - Utilities
extension FirebaseManager {
    
    private func fetchRoomFrom(snapshot: DataSnapshot) -> Room? {
        guard let value = snapshot.value as? [String: Any] else {
            return nil
        }
        
        let room: Room = Room()
        
        room.roomId = value["roomId"] as? String
        room.password = value["passowrd"] as? String
        room.roomName = value["roomName"] as? String
        room.ownerId = value["ownerId"] as? String

        
        var users: [WTUser] = []
        let content: Content = Content()
        var playlist: [Video] = []
        var messages: [Message] = []
        
       //MARK: - Users
        for child in (snapshot.childSnapshot(forPath: "Users").children.allObjects as! [DataSnapshot]) {
            let value = child.value as? NSDictionary
            let avatarId = value?.value(forKey: "avatarId") as? Int
            let birthdate = value?.value(forKey: "birthdate") as? String
            let email = value?.value(forKey: "email") as? String
            let fullName = value?.value(forKey: "fullName") as? String
            let userId = value?.value(forKey: "userId") as? String
            users.append(WTUser(userId: userId, avatarId: avatarId, fullName: fullName, email: email, birthdate: birthdate))
        }
        
        //MARK: - Content
        let contentSnapshot = snapshot.childSnapshot(forPath: "Content")
        let contentDict = contentSnapshot.value as? [String: Any]
        content.currentTime = contentDict?["currentTime"] as? Int
        content.isPlaying = contentDict?["isPlaying"] as? Bool
        
        let videoDict = contentSnapshot.childSnapshot(forPath: "Video").value as? [String: Any]
        content.video = Video(
            videoId: videoDict?["videoId"] as? String,
            title: videoDict?["title"] as? String,
            thumbnail: videoDict?["thumbnail"] as? String,
            channel: videoDict?["channel"] as? String,
            duration: videoDict?["duration"] as? Int)
        
        //MARK: - Playlist
        let playlistSnapshot = snapshot.childSnapshot(forPath: "Playlist")
        for child in (playlistSnapshot.children.allObjects as! [DataSnapshot]) {
            let value = child.value as? NSDictionary
            let videoId = value?.value(forKey: "videoId") as? String
            let title = value?.value(forKey: "title") as? String
            let thumbnail = value?.value(forKey: "thumbnail") as? String
            let channel = value?.value(forKey: "channel") as? String
            let duration = value?.value(forKey: "duration") as? Int
            playlist.append(
                Video(videoId: videoId,
                    title: title,
                    thumbnail: thumbnail,
                    channel: channel,
                    duration: duration))
        }
        
        //MARK: - Messages
         for child in (snapshot.childSnapshot(forPath: "Messages").children.allObjects as! [DataSnapshot]) {
             let value = child.value as? NSDictionary
             let messageId = value?.value(forKey: "messageId") as? String
             let text = value?.value(forKey: "text") as? String
             let ownerId = value?.value(forKey: "ownerId") as? String
             let sendTime = value?.value(forKey: "sendTime") as? String
             messages.append(Message(messageId: messageId, text: text, ownerId: ownerId, sendTime: sendTime))
         }
         
        
        room.content = content
        room.playlist = playlist
        room.users = users
        room.message = messages
        
        return room
        
    }

}


extension NSObject {
    func toDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        for case let (label?, value) in Mirror(reflecting: self)
            .children.map({ ($0.label, $0.value) }) {
            dict[label] = value
        }
        return dict
    }
}

class Room {
    
    var roomId: String?
    var password: String?
    var roomName: String?
    var ownerId: String?
    var content: Content?
    var playlist: [Video]?
    var users: [WTUser]?
    var message: [Message]?
    
    init(roomId: String? = nil, password: String? = nil, roomName: String? = nil, ownerId: String? = nil, content: Content? = nil, playlist: [Video]? = nil, users: [WTUser]? = nil, message: [Message]? = nil) {
        self.roomId = roomId
        self.password = password
        self.roomName = roomName
        self.ownerId = ownerId
        self.content = content
        self.playlist = playlist
        self.users = users
        self.message = message
    }
}

class Video: NSObject {
    
    var videoId: String?
    var title: String?
    var thumbnail: String?
    var channel: String?
    var duration: Int?
    
    init(videoId: String? = nil, title: String? = nil, thumbnail: String? = nil, channel: String? = nil, duration: Int? = nil) {
        self.videoId = videoId
        self.title = title
        self.thumbnail = thumbnail
        self.channel = channel
        self.duration = duration
    }
}

class Content {
    
    var video: Video?
    var currentTime: Int?
    var isPlaying: Bool?
    
    init(video: Video? = nil, currentTime: Int? = nil, isPlaying: Bool? = nil) {
        self.video = video
        self.currentTime = currentTime
        self.isPlaying = isPlaying
    }
}

class Message: NSObject {
    
    var messageId: String?
    var text: String?
    var ownerId: String?
    var sendTime: String?
    
    init(messageId: String? = nil, text: String? = nil, ownerId: String? = nil, sendTime: String? = nil) {
        self.messageId = messageId
        self.text = text
        self.ownerId = ownerId
        self.sendTime = sendTime
    }
}
