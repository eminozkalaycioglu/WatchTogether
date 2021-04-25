//
//  ProfileViewController.swift
//  WatchTogether
//
//  Created by emin on 25.04.2021.
//

import UIKit
import MaterialComponents.MDCOutlinedTextField

class ProfileViewController: WTViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var logoutButton: WTButton! {
        didSet {
            logoutButton.backgroundColor = .red
        }
    }
    @IBOutlet weak var updatePasswordStackView: UIStackView!
    @IBOutlet weak var currentPasswordField: MDCOutlinedTextField! {
        didSet {
            currentPasswordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            currentPasswordField.label.text = "Mevcut Şifre"
        }
    }
    @IBOutlet weak var newPasswordField: MDCOutlinedTextField! {
        didSet {
            newPasswordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            newPasswordField.label.text = "Yeni Şifre"
        }
    }
    @IBOutlet weak var confirmNewPasswordField: MDCOutlinedTextField! {
        didSet {
            confirmNewPasswordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            confirmNewPasswordField.label.text = "Şifre Tekrar"

        }
    }
    
    var viewModel: ProfileViewModel!
    
    override func setup() {
        super.setup()
        self.updatePasswordStackView.isHidden = true
        self.registerLoadableViewModel(viewModel: self.viewModel)
        if let avatarId = self.viewModel.getAvatarId() {
            self.avatarImageView.image = UIImage.avatar(id: avatarId)
        }
        
        self.fullNameLabel.text = self.viewModel.getFullName()
        self.emailLabel.text = self.viewModel.getEmail()
        
    }

    override func registerEvents() {
        super.registerEvents()
        
        self.viewModel.onPasswordUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.updatePasswordStackView.isHidden = true
                self?.newPasswordField.text?.removeAll()
                self?.confirmNewPasswordField.text?.removeAll()
                self?.currentPasswordField.text?.removeAll()
            }
        }
        
        self.viewModel.onLoggedOut = { [weak self] in
            DispatchQueue.main.async {
                self?.router.setRootViewController(SF.makeLoginVC())
            }
        }
    }
    @IBAction func pickAvatarButtonTapAction(_ sender: Any) {
        if let avatarId = self.viewModel.getAvatarId() {
            PickAvatarViewController.showOverCurrentContent(context: self, delegate: self, selectedAvatarId: avatarId)
        }
        
    }
    
    @IBAction func showUpdatePasswordButtonTapAction(_ sender: Any) {
        self.updatePasswordStackView.isHidden = !self.updatePasswordStackView.isHidden
        
    }
    
    @IBAction func updatePasswordButtonTapAction(_ sender: Any) {
        guard let newPassword = self.newPasswordField.text,
              let confirmNewPassword = self.confirmNewPasswordField.text,
              let currentPassword = self.currentPasswordField.text,
              newPassword == confirmNewPassword else { return }
        
        self.viewModel.updatePassword(
            currentPassword: currentPassword,
            newPassword: newPassword)
    }
    @IBAction func logoutButtonTapAction(_ sender: Any) {
        self.viewModel.logout()
    }
}

extension ProfileViewController: PickAvatarViewControllerDelegate {
    func pickAvatarViewControllerDidClose(controller: PickAvatarViewController?) {
        PickAvatarViewController.hide(context: self, pickAvatarController: controller)
    }
    
    func pickAvatarViewControllerDidSelect(controller: PickAvatarViewController?, avatarId: Int) {
        self.viewModel.updateAvatar(newAvatarId: avatarId) { [weak self] (newAvatarId) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.avatarImageView.image = UIImage.avatar(id: newAvatarId)
                PickAvatarViewController.hide(context: self, pickAvatarController: controller)
            }

        }
        
    }
}
