//
//  TestViewController.swift
//  WatchTogether
//
//  Created by emin on 9.04.2021.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = Message(messageId: "id", text: "tex", ownerId: "owid", sendTime: "sendtime")
        
        let testId = "D277198A-1649-433B-96E1-F9D0F0F8FA51"
        
        if WTSessionManager.shared.isLoggedIn {
            WTSessionManager.shared.fetchUser {
                
                FirebaseManager.shared.fetchRooms { (result) in
                    switch result {
                    case let .success(rooms):
                        print("")
                    case let .failure(error):
                        print(error.message)
                    }
                }
//                FirebaseManager.shared.createRoom(ownerUser: WTSessionManager.shared.user!, roomName: "Deneme", password: nil) { (result) in
//                    switch result {
//                    case .success:
//                        print("oda kuruldu")
//                    case let .failure(error):
//                        print(error.message)
//                    }
//                }
            }
            
        }
        
        
    }

    


    @IBAction func registerButtonTapAction(_ sender: Any) {
        guard let email = emailField.text,
              let password = passwordField.text,
              let fullname = fullnameField.text else { return }
        
        let request = RegisterRequestModel(
            email: email,
            password: password,
            fullName: fullname,
            birthdate: "1999-12-12",
            avatarId: 2)
        
        FirebaseManager.shared.register(request) { (result) in
            switch result {
            case let .failure(error):
                print("emintest: \(error.message)")
                
            case let .success(user):
                WTSessionManager.shared.loggedIn(user: user)
                print("emintest: success \(user.email)")
            }
        }
    }
    
    @IBAction func createRoomTapAction(_ sender: Any) {
        
        if WTSessionManager.shared.isLoggedIn {
            WTSessionManager.shared.fetchUser {
                FirebaseManager.shared.fetchRoom(roomId: "D277198A-1649-433B-96E1-F9D0F0F8FA51") { (result) in
                    switch result {
                    case let .success(room):
                        print("emintest: success!!")
                        
                    case let .failure(error):
                        print("emintest: error \(error.message)")
                    }
                }
            }
        }
    }
}
