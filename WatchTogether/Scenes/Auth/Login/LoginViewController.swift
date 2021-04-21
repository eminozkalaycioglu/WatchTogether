//
//  LoginViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class LoginViewController: WTViewController {
    
    @IBOutlet weak var passwordField: MDCOutlinedTextField! {
        didSet {
            passwordField.wtTheme(icon: R.image.passwordIcon()!, inputType: .password)
            passwordField.label.text = "Şifre"
        }
    }
    @IBOutlet weak var emailField: MDCOutlinedTextField! {
        didSet {
            emailField.wtTheme(icon: R.image.emailIcon()!)
            emailField.label.text = "E-mail"
            
        }
    }
    
    @IBOutlet weak var loginButton: WTButton! {
        didSet {
            loginButton.setTitle("Oturum Aç", for: .normal)
        }
    }
    
    var viewModel: LoginViewModel!
    
    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
        self.view.backgroundColor = R.color.mainBlueColorDark()!
        self.navigation.bar.isHidden = false

    }
    
    override func registerEvents() {
        super.registerEvents()
        self.viewModel.onUserLoggedIn = { [weak self] in
            DispatchQueue.main.async {
                self?.router.setRootViewController(SF.makeMainTabBar())
            }
        }
    }
    
    @IBAction func registerButtonTapAction(_ sender: Any) {
        self.navigationController?.pushViewController(SF.makeRegisterVC(), animated: true)
    }
    
    @IBAction func loginButtonTapAction(_ sender: Any) {
        guard let email = self.emailField.text,
              let pass = self.passwordField.text else { return }
        
        self.viewModel.login(email: email, password: pass)
        
    }
}
