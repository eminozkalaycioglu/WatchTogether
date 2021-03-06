//
//  FirebaseManager.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import Foundation
import Firebase

protocol FirebaseManager {
    
    //MARK: - Auth
    var dbRef: DatabaseReference { get set }
    func saveUserInfo(_ request: RegisterRequestModel, uid: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func register(_ request: RegisterRequestModel, completion: @escaping ((Result<WTUser, PresentableError>)->Void))
    func fetchUserInfo(uid: String, completion: @escaping ((Result<WTUser, PresentableError>)->Void))
    func signOut() -> Bool
    func getCurrentAuthUser() -> User?
    func login(email: String, password: String, completion: @escaping ((Result<WTUser, PresentableError>)->Void))
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping ((Result<Bool, PresentableError>)->Void))
    func editAvatar(uid: String, newAvatarId: Int, completion: @escaping ((Result<Int, PresentableError>)->Void))
    
    //MARK: - Room
    func createRoom(ownerUser: WTUser, roomName: String, password: String?, completion: @escaping ((Result<Room, PresentableError>) -> Void))
    func joinRoom(user: WTUser, roomId: String, password: String?, completion: @escaping ((Result<Room, PresentableError>) -> Void))
    func observeAutoSync(roomId: String, completion: @escaping (() -> Void))
    func autoSync(roomId: String)
    func fetchRooms(completion: @escaping ((Result<[Room], PresentableError>) -> Void))
    func fetchRoom(roomId: String, completion: @escaping ((Result<Room, PresentableError>) -> Void))
    func addVideoToRoomPlaylist(roomId: String, video: Video, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func fetchPlaylist(roomId: String, completion: @escaping ((Result<[Video], PresentableError>) -> Void))
    func fetchContent(roomId: String, completion: @escaping ((Result<Content, PresentableError>) -> Void))
    func fetchIsPlaying(roomId: String, completion: @escaping ((Bool?) -> Void))
    func addUserToRoom(roomId: String, user: WTUser, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func addMessageToRoom(roomId: String, message: Message, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func addContentToRoom(roomId: String, video: Video, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func deleteVideoFromPlaylist(roomId: String, videoId: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func setPlaying(roomId: String, state: Bool)
    func setCurrentTime(roomId: String, second: Float)
    func setPlayingAndCurrentTime(roomId: String, state: Bool, second: Float)
    func observeMessages(roomId: String, completion: @escaping ((Message) -> Void))
    func observeRoomDeleting(completion: @escaping ((Room?) -> Void))
    func fetchRoomUserInfos(ids: [String], completion: @escaping ((Result<[WTUser], PresentableError>)->Void))
    func exitRoom(uid: String, roomId: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func deleteRoom(roomId: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void))
    func observeRoomAdding(completion: @escaping ((Room?) -> Void))
    func observeNewRoomUsers(roomId: String, completion: @escaping (() -> Void))
    func observePlaylist(roomId: String, completion: @escaping (() -> Void))
    func removeRoomObservers()
    func observeRoomUsers(roomId: String, completion: @escaping (() -> Void))
    func observeContent(roomId: String, completion: @escaping ((Result<Content, PresentableError>) -> Void))
    func observeContentCurrentTime(roomId: String, completion: @escaping ((Float?) -> Void))
    func observeContentIsPlaying(roomId: String, completion: @escaping ((Bool?) -> Void))
    func observeContentVideo(roomId: String, completion: @escaping ((Video, Float) -> Void))
    
    //MARK: - Utilities
    func fetchRoomFrom(snapshot: DataSnapshot) -> Room?
    
}

final class WTFirebaseManager: FirebaseManager {
    
    private init() { }
    
    static let shared = WTFirebaseManager()

    internal var dbRef: DatabaseReference = Database.database().reference()
    
    func test() {
        self.dbRef.child("Testa").setValue(["val" : Int.random(in: 0..<99999)])
    }
    
}

//MARK: - Auth Functions
extension WTFirebaseManager {
    
    internal func saveUserInfo(_ request: RegisterRequestModel, uid: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        
        var dict: [String: Any] = [:]
        dict["userId"] = uid
        dict["avatarId"] = request.avatarId
        dict["fullName"] = request.fullName
        dict["email"] = request.email
        
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
                            email: request.email)
                        completion(.success(user))
                    case let .failure(presentableError):
                        completion(.failure(presentableError))
                    }
                }
                
            }
        }
    }
    
    func fetchUserInfo(uid: String, completion: @escaping ((Result<WTUser, PresentableError>)->Void)) {
        
        self.dbRef.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.failure(.init(message: " fetchUserInfo Parse Error")))
                return
            }
            
            let userId = value["userId"] as? String
            let avatarId = value["avatarId"] as? Int
            let fullName = value["fullName"] as? String
            let email = value["email"] as? String
            
            let user = WTUser(
                userId: userId,
                avatarId: avatarId,
                fullName: fullName,
                email: email)
            
            completion(.success(user))
            
        }
        
    }
    
    func fetchRoomUserInfos(ids: [String], completion: @escaping ((Result<[WTUser], PresentableError>)->Void)) {
        
        var users: [WTUser]  = []
        
        if ids.count == 0 {
            completion(.success([]))
        }
        for id in ids {
            self.fetchUserInfo(uid: id) { (result) in
                switch result {
                case let .success(user):
                    users.append(user)
                    if users.count == ids.count {
                        completion(.success(users))
                    }
                case let .failure(error):
                    completion(.failure(error))
                    return
                }
            }
            
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
    
    func login(email: String, password: String, completion: @escaping ((Result<WTUser, PresentableError>)->Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (firResult, firError) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
                return
            } else if let firResult = firResult {
                self.fetchUserInfo(uid: firResult.user.uid, completion: completion)
            }
        }
        
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping ((Result<Bool, PresentableError>)->Void)) {
        
        guard let email = self.getCurrentAuthUser()?.email else { return }
        
        let authCredential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        self.getCurrentAuthUser()?.reauthenticate(with: authCredential, completion: { (_, reAuthError) in
            if let reAuthError = reAuthError {
                completion(.failure(reAuthError.presentableError))
                return
            } else {
                self.getCurrentAuthUser()?.updatePassword(to: newPassword, completion: { (firError) in
                    if let firError = firError {
                        completion(.failure(firError.presentableError))
                        return
                    } else {
                        completion(.success(true))
                    }
                })
            }
        })
        
        
    }
    
    func editAvatar(uid: String, newAvatarId: Int, completion: @escaping ((Result<Int, PresentableError>)->Void)) {
        
        self.dbRef.child("Users").child(uid).updateChildValues(
            ["avatarId": newAvatarId]) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(newAvatarId))
            }
        }
    }
}

//MARK: - Room Functions
extension WTFirebaseManager {
    
    func createRoom(ownerUser: WTUser, roomName: String, password: String?, completion: @escaping ((Result<Room, PresentableError>) -> Void)) {
        
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
                self.joinRoom(user: ownerUser, roomId: roomId, password: password, completion: completion)
            }
        }
        
    }
    
    func exitRoom(uid: String, roomId: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
                
        self.dbRef.child("Rooms").child(roomId).child("OldUsers").child(uid).setValue(uid) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                self.dbRef.child("Rooms").child(roomId).child("Users").child(uid).removeValue()
                completion(.success(true))
            }
        }
        
    }
    
    func deleteRoom(roomId: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).removeValue { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func deleteVideoFromPlaylist(roomId: String, videoId: String, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Playlist").child(videoId).removeValue { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }
    }

    func joinRoom(user: WTUser, roomId: String, password: String?, completion: @escaping ((Result<Room, PresentableError>) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let room = self.fetchRoomFrom(snapshot: snapshot) else {
                completion(.failure(.init(message: " joinRoom Parse Error")))
                return
            }
            
            if room.password != nil, password != room.password! {
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

    func autoSync(roomId: String) {
        self.dbRef.child("Rooms").child(roomId).child("autoSync").setValue(Int.random(in:0..<999999))
    }
    
    func observeAutoSync(roomId: String, completion: @escaping (() -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("autoSync").observe(.value) { snapshot in
            if snapshot.value != nil {
                completion()
            }
        }
    }
    
    func fetchRooms(completion: @escaping ((Result<[Room], PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                completion(.success([]))
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
    
    func fetchRoom(roomId: String, completion: @escaping ((Result<Room, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).observeSingleEvent(of: .value) { (snapshot) in
            guard let room = self.fetchRoomFrom(snapshot: snapshot) else {
                return
            }
            completion(.success(room))

        }
    }
    
    func addVideoToRoomPlaylist(roomId: String, video: Video, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Playlist").child(video.videoId ?? "").setValue(video.toDict()) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func fetchPlaylist(roomId: String, completion: @escaping ((Result<[Video], PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Playlist").observeSingleEvent(of: .value) { (snapshot) in
            
            var playlist: [Video] = []
            for child in (snapshot.children.allObjects as! [DataSnapshot]) {
                let value = child.value as? NSDictionary
                let videoId = value?.value(forKey: "videoId") as? String
                let title = value?.value(forKey: "title") as? String
                let thumbnail = value?.value(forKey: "thumbnail") as? String
                let channel = value?.value(forKey: "channel") as? String
                let sendTime = value?.value(forKey: "sendTime") as? String
                playlist.append(
                    Video(videoId: videoId,
                        title: title,
                        thumbnail: thumbnail,
                        channel: channel,
                        sendTime: sendTime))
            }
            
            completion(.success(playlist))
        }
    }
    
    func fetchContent(roomId: String, completion: @escaping ((Result<Content, PresentableError>) -> Void)) {
        self.dbRef.child("Rooms").child(roomId).child("Content").observeSingleEvent(of: .value) { (snapshot) in
            
            self.getContentFrom(snapshot: snapshot, completion: completion)
        }
    }
    
    func fetchIsPlaying(roomId: String, completion: @escaping ((Bool?) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Content").child("isPlaying").observe(.value, with: { (snapshot) in
            completion(snapshot.value as? Bool)
        })
    }
    

    func addContentToRoom(roomId: String, video: Video, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        
        let dict: [String: Any] = [
            "currentTime": Float(0.0),
            "isPlaying": true,
            "Video": video.toDict()
        ]
        
        self.dbRef.child("Rooms").child(roomId).child("Content").setValue(dict) { (firError, _) in
            if let firError = firError {
                completion(.failure(firError.presentableError))
                return
            } else {
                completion(.success(true))
            }
            
        }
        
    }
    
    func setPlayingAndCurrentTime(roomId: String, state: Bool, second: Float) {
        let dict: [String: Any] = [
            "isPlaying": state,
            "currentTime": second
        ]
        self.dbRef.child("Rooms").child(roomId).child("Content").updateChildValues(dict)
    }
    
    func setPlaying(roomId: String, state: Bool) {
        self.dbRef.child("Rooms").child(roomId).child("Content").updateChildValues(["isPlaying": state])
    }

    func setCurrentTime(roomId: String, second: Float) {
        self.dbRef.child("Rooms").child(roomId).child("Content").updateChildValues(["currentTime": second])
    }
    
    func addUserToRoom(roomId: String, user: WTUser, completion: @escaping ((Result<Bool, PresentableError>) -> Void)) {
        
        guard let userId = user.userId else { return }
        
        self.dbRef.child("Rooms").child(roomId).child("OldUsers").child(userId).removeValue()
        
        self.dbRef.child("Rooms").child(roomId).child("Users").child(userId).setValue(userId) { (firError, _) in
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
    
    func observeMessages(roomId: String, completion: @escaping ((Message) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Messages").observe(.childAdded) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            let messageId = value.value(forKey: "messageId") as? String
            let text = value.value(forKey: "text") as? String
            let ownerId = value.value(forKey: "ownerId") as? String
            let sendTime = value.value(forKey: "sendTime") as? String
            let message = Message(messageId: messageId, text: text, ownerId: ownerId, sendTime: sendTime)
            completion(message)
        }
    }
    
    func observeRoomUsers(roomId: String, completion: @escaping (() -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Users").observe(.value) { (_) in
            print("emintest observe room users changed")
            completion()
        }

    }
    
    func observeNewRoomUsers(roomId: String, completion: @escaping (() -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Users").observe(.childAdded) { (_) in
            completion()
        }

    }
    
    func observeRoomDeleting(completion: @escaping ((Room?) -> Void)) {
        self.dbRef.child("Rooms").observe(.childRemoved, with: { (snapshot) in
            completion(self.fetchRoomFrom(snapshot: snapshot))
        })
    }
    
    func observeRoomAdding(completion: @escaping ((Room?) -> Void)) {
        
        self.dbRef.child("Rooms").observe(.childAdded, with: { (snapshot) in
            print("oberve action room add")
            completion(self.fetchRoomFrom(snapshot: snapshot))
        })
    }
    
    func observePlaylist(roomId: String, completion: @escaping (() -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Playlist").observe(.value, with: { (_) in
            completion()
        })
    }
    
    func observeContent(roomId: String, completion: @escaping ((Result<Content, PresentableError>) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Content").observe(.value, with: { (snapshot) in
            self.getContentFrom(snapshot: snapshot) { (result) in
                switch result {
                case let .success(content):
                    if content.video?.videoId != nil {
                        completion(.success(content))
                    }
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            self.getContentFrom(snapshot: snapshot, completion: completion)
        })
    }
    
    func observeContentVideo(roomId: String, completion: @escaping ((Video, Float) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Content").child("Video").observe(.value, with: { (contentSnapshot) in
            
            self.dbRef.child("Rooms").child(roomId).child("Content").child("currentTime").observeSingleEvent(of: .value) { (currentTimeSnapshot) in
                
                let currentTime = currentTimeSnapshot.value as? Float
                let videoDict = contentSnapshot.value as? [String: Any]
                let video = Video(
                    videoId: videoDict?["videoId"] as? String,
                    title: videoDict?["title"] as? String,
                    thumbnail: videoDict?["thumbnail"] as? String,
                    channel: videoDict?["channel"] as? String,
                    sendTime: videoDict?["sendTime"] as? String)
                completion(video, currentTime ?? 0)
                
            }
            
            
        })
    }
    
    func observeContentIsPlaying(roomId: String, completion: @escaping ((Bool?) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Content").child("isPlaying").observe(.value, with: { (snapshot) in
            
            completion(snapshot.value as? Bool)
        })
    }
    
    func observeContentCurrentTime(roomId: String, completion: @escaping ((Float?) -> Void)) {
        
        self.dbRef.child("Rooms").child(roomId).child("Content").child("currentTime").observe(.value, with: { (snapshot) in
            completion(snapshot.value as? Float)
        })
    }

    
    func removeRoomObservers() {
        self.dbRef.child("Rooms").removeAllObservers()
    }
    
}


//MARK: - Utilities
extension WTFirebaseManager {
    
    internal func fetchRoomFrom(snapshot: DataSnapshot) -> Room? {
        guard let value = snapshot.value as? [String: Any] else {
            return nil
        }
        
        let room: Room = Room()
        
        room.roomId = value["roomId"] as? String
        room.password = value["password"] as? String
        room.roomName = value["roomName"] as? String
        room.ownerId = value["ownerId"] as? String

        
        var users: [String] = []
        var oldUsers: [String] = []
        let content: Content = Content()
        var playlist: [Video] = []
        var messages: [Message] = []
        
       //MARK: - Users
        for child in (snapshot.childSnapshot(forPath: "Users").children.allObjects as! [DataSnapshot]) {
            if let userId = child.value as? String {
                users.append(userId)
            }
        }
        
        //MARK: - OldUsers
        for child in (snapshot.childSnapshot(forPath: "OldUsers").children.allObjects as! [DataSnapshot]) {
            if let userId = child.value as? String {
                oldUsers.append(userId)
            }
        }
        
        //MARK: - Content
        let contentSnapshot = snapshot.childSnapshot(forPath: "Content")
        let contentDict = contentSnapshot.value as? [String: Any]
        content.currentTime = contentDict?["currentTime"] as? Float
        content.isPlaying = contentDict?["isPlaying"] as? Bool
        
        let videoDict = contentSnapshot.childSnapshot(forPath: "Video").value as? [String: Any]
        content.video = Video(
            videoId: videoDict?["videoId"] as? String,
            title: videoDict?["title"] as? String,
            thumbnail: videoDict?["thumbnail"] as? String,
            channel: videoDict?["channel"] as? String,
            sendTime: videoDict?["sendTime"] as? String)
        
        //MARK: - Playlist
        let playlistSnapshot = snapshot.childSnapshot(forPath: "Playlist")
        for child in (playlistSnapshot.children.allObjects as! [DataSnapshot]) {
            let value = child.value as? NSDictionary
            let videoId = value?.value(forKey: "videoId") as? String
            let title = value?.value(forKey: "title") as? String
            let thumbnail = value?.value(forKey: "thumbnail") as? String
            let channel = value?.value(forKey: "channel") as? String
            let sendTime = value?.value(forKey: "sendTime") as? String
            playlist.append(
                Video(videoId: videoId,
                    title: title,
                    thumbnail: thumbnail,
                    channel: channel,
                    sendTime: sendTime))
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
        room.oldUsers = oldUsers
        
        return room
        
    }
    
    func getContentFrom(snapshot: DataSnapshot, completion: @escaping ((Result<Content, PresentableError>) -> Void)) {
        let content = Content()
        guard let contentDict = snapshot.value as? [String: Any] else {
            completion(.failure(.init(message: "getContentFrom Parse Error")))
            return
        }
        
        content.currentTime = contentDict["currentTime"] as? Float
        content.isPlaying = contentDict["isPlaying"] as? Bool
        
        let videoDict = snapshot.childSnapshot(forPath: "Video").value as? [String: Any]
        content.video = Video(
            videoId: videoDict?["videoId"] as? String,
            title: videoDict?["title"] as? String,
            thumbnail: videoDict?["thumbnail"] as? String,
            channel: videoDict?["channel"] as? String,
            sendTime: videoDict?["sendTime"] as? String)
        completion(.success(content))
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
    var users: [String]?
    var oldUsers: [String]?
    var message: [Message]?
    
    init(roomId: String? = nil, password: String? = nil, roomName: String? = nil, ownerId: String? = nil, content: Content? = nil, playlist: [Video]? = nil, users: [String]? = nil, oldUsers: [String]? = nil, message: [Message]? = nil) {
        self.roomId = roomId
        self.password = password
        self.roomName = roomName
        self.ownerId = ownerId
        self.content = content
        self.playlist = playlist
        self.users = users
        self.oldUsers = oldUsers
        self.message = message
    }
}

class Video: NSObject {
    
    var videoId: String?
    var title: String?
    var thumbnail: String?
    var channel: String?
    var sendTime: String?
    
    init(videoId: String? = nil, title: String? = nil, thumbnail: String? = nil, channel: String? = nil, sendTime: String? = nil) {
        self.videoId = videoId
        self.title = title
        self.thumbnail = thumbnail
        self.channel = channel
        self.sendTime = sendTime
    }
}

class Content {
    
    var video: Video?
    var currentTime: Float?
    var isPlaying: Bool?
    
    init(video: Video? = nil, currentTime: Float? = nil, isPlaying: Bool? = nil) {
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
