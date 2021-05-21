//
//  RoomTVC.swift
//  WatchTogether
//
//  Created by emin on 1.05.2021.
//

import UIKit
import MarqueeLabel
import Kingfisher

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
        if let thumbnail = room?.content?.video?.thumbnail {
            self.thumbnailImageView.kf.setImage(with: URL(string: thumbnail))
        }
        
        self.roomNameLabel.text = room?.roomName
        self.videoTitleLabel.text = room?.content?.video?.title
        self.userCountLabel.text = "\(room?.users?.count ?? 0)"
        if let color = self.colors.randomElement() {
            self.userCountView.backgroundColor = color
        }
        
        self.specialRoomView.isHidden = (room?.password == nil)
    }

}
