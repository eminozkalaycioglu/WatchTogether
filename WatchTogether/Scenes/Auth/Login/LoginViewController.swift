//
//  LoginViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit

class LoginViewController: WTViewController {
    var viewModel: LoginViewModel!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
    }
    override func registerEvents() {
        super.registerEvents()
        self.viewModel.onUserLoggedIn = { [weak self] in
            DispatchQueue.main.async {
                self?.router.setRootViewController(SF.makeMainTabBar())
            }
        }
    }
    @IBAction func loginTap(_ sender: Any) {
        guard let email = self.emailField.text,
              let pass = self.passwordField.text else { return }
        
        self.viewModel.login(email: email, password: pass)
        
    }
}
