//
//  CreateRoomViewController.swift
//  WatchTogether
//
//  Created by emin on 25.04.2021.
//

import UIKit
import MaterialComponents.MDCOutlinedTextField

class CreateRoomViewController: WTViewController {
    @IBOutlet weak var roomNameField: MDCOutlinedTextField! {
        didSet {
            roomNameField.wtTheme(icon: nil)
            roomNameField.label.text = "Yayın Adı Giriniz"
        }
    }
    @IBOutlet weak var passwordField: MDCOutlinedTextField! {
        didSet {
            passwordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            passwordField.label.text = "Şifre"
        }
    }
    @IBOutlet weak var confirmPasswordField: MDCOutlinedTextField! {
        didSet {
            confirmPasswordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            confirmPasswordField.label.text = "Şifre Tekrar"

        }
    }
    @IBOutlet weak var passwordStackView: UIStackView!
    
    @IBOutlet weak var publicRoomSwitch: UISwitch!
    
    var viewModel: CreateRoomViewModel!
    
    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
        self.publicRoomSwitch.isOn = true
        self.passwordStackView.isHidden = true
    }

    override func registerEvents() {
        super.registerEvents()
        
        self.viewModel.onRoomCreated = { [weak self] room in
            DispatchQueue.main.async {
                let roomVC = SF.makeRoomVC(room: room)
                self?.navigationController?.pushViewController(roomVC, animated: true)
            }
        }
    }
    @IBAction func createRoomButtonTapAction(_ sender: Any) {
        
        guard let roomName = self.roomNameField.text else { return }
        
        if self.passwordStackView.isHidden {
            self.viewModel.createRoom(roomName: roomName, password: nil)
        } else {
            guard let password = self.passwordField.text,
                  let confirmPassword = self.confirmPasswordField.text,
                  password.count >= 1,
                  confirmPassword == password else { return }
            self.viewModel.createRoom(roomName: roomName, password: password)
        }
        
    }
    @IBAction func publicRoomSwitchValueChanged(_ sender: Any) {
        self.passwordStackView.isHidden = self.publicRoomSwitch.isOn
    }
}
