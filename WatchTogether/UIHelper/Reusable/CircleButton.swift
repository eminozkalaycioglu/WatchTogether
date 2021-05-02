//
//  CircleButton.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.height / 2
        self.setTitle("", for: .normal)
    }
}
