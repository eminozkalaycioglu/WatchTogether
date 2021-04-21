//
//  RegisterViewController.swift
//  WatchTogether
//
//  Created by emin on 21.04.2021.
//

import UIKit

class RegisterViewController: WTViewController {

    var viewModel: RegisterViewModel!
    
    override func setup() {
        super.setup()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            PickAvatarViewController.showOverCurrentContent(context: self, delegate: self)
        }
        
    }
}

extension RegisterViewController: PickAvatarViewControllerDelegate {
    func pickAvatarViewControllerDidSelect(controller: PickAvatarViewController?, avatarId: Int) {
        print("selected id: \(avatarId)")
        
    }
    
    func pickAvatarViewControllerDidClose(controller: PickAvatarViewController?) {
        PickAvatarViewController.hide(context: self, pickAvatarController: controller)

    }
}
