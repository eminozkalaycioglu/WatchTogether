//
//  RegisterViewController.swift
//  WatchTogether
//
//  Created by emin on 21.04.2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class RegisterViewController: WTViewController {
    
    @IBOutlet weak var fullNameField: MDCOutlinedTextField! {
        didSet {
            fullNameField.wtTheme(icon: R.image.personIcon()!)
            fullNameField.label.text = "Ad Soyad"
        }
    }
    
    @IBOutlet weak var emailField: MDCOutlinedTextField! {
        didSet {
            emailField.wtTheme(icon: R.image.emailIcon()!)
            emailField.label.text = "E-mail"
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
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var registerButton: WTButton!
    
    var viewModel: RegisterViewModel!
    
    private var randomAvatarId = Int.random(in: 1..<(AppConstants.avatarCount + 1))
    
    private var selectedAvatarId: Int?
    
    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
        self.avatarImageView.image = UIImage.avatar(id: self.randomAvatarId)
        self.selectedAvatarId = self.randomAvatarId
    }
    
    override func registerEvents() {
        super.registerEvents()
        self.viewModel.onUserLoggedIn = { [weak self] in
            DispatchQueue.main.async {
                self?.router.setRootViewController(SF.makeMainTabBar())
            }
        }
    }
    
    @IBAction func editButtonTapAction(_ sender: Any) {
        DispatchQueue.main.async {
            PickAvatarViewController.showOverCurrentContent(context: self, delegate: self, selectedAvatarId: self.randomAvatarId)
        }
    }
    
    @IBAction func loginButtonTapAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registerButtonTapAction(_ sender: Any) {
        
        guard let fullName = self.fullNameField.text,
              let email = self.emailField.text,
              let password = self.passwordField.text,
              let confirmPassword = self.confirmPasswordField.text,
              password == confirmPassword,
              let avatarId = self.selectedAvatarId else { return }
        
        let request = RegisterRequestModel(
            email: email,
            password: password,
            fullName: fullName,
            avatarId: avatarId)
        
        self.viewModel.register(request)
    }
}

extension RegisterViewController: PickAvatarViewControllerDelegate {
    func pickAvatarViewControllerDidSelect(controller: PickAvatarViewController?, avatarId: Int) {
        self.avatarImageView.image = UIImage.avatar(id: avatarId)
        self.selectedAvatarId = avatarId
        PickAvatarViewController.hide(context: self, pickAvatarController: controller)
        
    }
    
    func pickAvatarViewControllerDidClose(controller: PickAvatarViewController?) {
        PickAvatarViewController.hide(context: self, pickAvatarController: controller)

    }
}
