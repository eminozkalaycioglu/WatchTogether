//
//  RoomTVC.swift
//  WatchTogether
//
//  Created by emin on 1.05.2021.
//

import UIKit
import MarqueeLabel

class RoomTVC: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: MarqueeLabel!
    @IBOutlet weak var roomNameLabel: MarqueeLabel!
    @IBOutlet weak var userCountView: UIView!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var specialRoomView: UIView!
    
    private let colors: [UIColor] = [
        R.color.userCountRed()!,
        R.color.userCountGreen()!,
        R.color.userCountOrange()!,
        R.color.userCountTurquoise()!
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 7
        
        self.userCountView.clipsToBounds = true
        self.userCountView.layer.cornerRadius = 7
        self.userCountView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        
        self.specialRoomView.clipsToBounds = true
        self.specialRoomView.layer.cornerRadius = 7
        self.specialRoomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    func configureCell(room: Room?) {
        self.roomNameLabel.text = room?.roomName
        self.videoTitleLabel.text = room?.content?.video?.title
        self.userCountLabel.text = "\(room?.users?.count ?? 0)"
        if let color = self.colors.randomElement() {
            self.userCountView.backgroundColor = color
        }
        
        self.specialRoomView.isHidden = (room?.password == nil)
    }

}


@IBDesignable
public class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }

}
