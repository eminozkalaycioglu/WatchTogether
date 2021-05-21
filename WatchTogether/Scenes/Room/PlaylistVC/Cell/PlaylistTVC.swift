//
//  PlaylistTVC.swift
//  WatchTogether
//
//  Created by emin on 21.05.2021.
//

import UIKit
import MarqueeLabel
import Kingfisher
import Reusable

class PlaylistTVC: UITableViewCell, NibReusable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoTitleLabel: MarqueeLabel!
    @IBOutlet weak var videoChannelLabel: MarqueeLabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var onTappedDeleteButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 5
    }

    func configureCell(video: Video) {
        if let url = URL(string: video.thumbnail ?? "") {
            self.thumbnailImageView.kf.setImage(with: url)
        }
        self.videoChannelLabel.text = video.channel
        self.videoTitleLabel.text = video.title
    }
    
    @IBAction func deleteButtonTapAction(_ sender: Any) {
        self.onTappedDeleteButton?()
    }
}
