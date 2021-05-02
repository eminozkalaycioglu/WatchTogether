//
//  MessageTextField.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import Foundation
import UIKit

class MessageTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private lazy var paddingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.bounds.height))
        return view
    }()
    
    func commonInit() {
        self.leftView = self.paddingView
        self.leftViewMode = .always
        self.textColor = R.color.whiteAlpha075()!
        self.font = R.font.kanitRegular(size: 14)
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.backgroundColor = R.color.mainBlueColorDark()!
        self.placeholder = ""
    }
}



