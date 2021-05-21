//
//  RoomTypeSelectionView.swift
//  WatchTogether
//
//  Created by emin on 19.05.2021.
//

import Foundation
import UIKit
import Reusable
enum RoomType {
    case `public`
    case `private`
}

protocol RoomTypeSelectionViewDelegate: class {
    func roomTypeSelectionViewDidSelect(_ view: RoomTypeSelectionView?, selection: RoomType)
}

class RoomTypeSelectionView: BaseNibView {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var publicButton: UIButton!
    @IBOutlet weak var privateButton: UIButton!
    
    var roomType: RoomType = .public {
        didSet {
            self.delegate?.roomTypeSelectionViewDidSelect(self, selection: roomType)
        }
    }
    
    weak var delegate: RoomTypeSelectionViewDelegate?
    
    override func commonInit() {
        super.commonInit()
        
        self.backgroundColor = .clear
        
        self.stackView.clipsToBounds = true
        self.stackView.layer.cornerRadius = 18
        
        self.privateButton.clipsToBounds = true
        self.privateButton.layer.cornerRadius = 16
        
        self.publicButton.clipsToBounds = true
        self.publicButton.layer.cornerRadius = 16
        
        self.publicButton.backgroundColor = R.color.registerGreenColor()!
        self.privateButton.backgroundColor = .clear
    }
    @IBAction func publicButtonTapAction(_ sender: Any) {
        guard self.roomType != .public else { return }
        self.roomType = .public
        self.publicButton.backgroundColor = R.color.registerGreenColor()!
        self.privateButton.backgroundColor = .clear
        
    }
    @IBAction func privateButtonTapAction(_ sender: Any) {
        guard self.roomType != .private else { return }
        self.roomType = .private
        self.publicButton.backgroundColor = .clear
        self.privateButton.backgroundColor = R.color.registerGreenColor()!
    }
}

class BaseNibView: BaseView, NibOwnerLoadable {
    
    override func commonInit() {
        loadNibContent()
    }
}

class BaseView: UIView {
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 2
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            self.layer.shadowOffset = shadowOffset
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet {
            self.layer.shadowOpacity = Float(shadowOpacity)
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
            self.layer.masksToBounds = false
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() { }
}
