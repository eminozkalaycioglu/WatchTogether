//
//  WTViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import Foundation
import UIKit

class WTViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func setup() {
        super.setup()
        
        if self.navigationController?.navigation.configuration.isEnabled == true {
            navigation.item.titleView = UIImageView(image: R.image.logo()!)
        }
    }
}
