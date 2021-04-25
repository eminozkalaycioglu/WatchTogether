//
//  WTCardStackView.swift
//  WatchTogether
//
//  Created by emin on 25.04.2021.
//

import Foundation
import UIKit


@IBDesignable
class WTCardStackView: UIStackView {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    private func setUI() {
        self.layer.cornerRadius = 5
        self.backgroundColor = R.color.cardBackgroundColor()!
    }
}
