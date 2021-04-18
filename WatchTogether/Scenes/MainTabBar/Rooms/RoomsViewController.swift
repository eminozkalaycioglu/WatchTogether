//
//  RoomsViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit

class RoomsViewController: WTViewController {


    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var viewModel: RoomsViewModel!
    override func setup() {
        super.setup()
        let user = self.viewModel.getUser()
        
        self.emailLabel.text = user?.email
        self.birthdateLabel.text = user?.birthdate
        self.nameLabel.text = user?.fullName
        
    }
    
    @IBAction func logoutTap(_ sender: Any) {
        WTSessionManager.shared.logOut {
            self.router.setRootViewController(SF.makeLoginVC())
        }
    }
}
