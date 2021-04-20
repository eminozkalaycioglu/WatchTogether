//
//  WTButton.swift
//  WatchTogether
//
//  Created by emin on 20.04.2021.
//

import Foundation
import UIKit

class WTButton: BaseButton {
    
    override func commonInit() {
        super.commonInit()
        self.contentEdgeInsets = UIEdgeInsets(top: 8, left: 22, bottom: 8, right: 22)
        self.cornerRadius = 3
        self.backgroundColor = R.color.buttonBlueColor()!
        self.titleColor = R.color.whiteAlpha075()!
        self.titleFont = R.font.kanitRegular(size: 20)!
    }
}
