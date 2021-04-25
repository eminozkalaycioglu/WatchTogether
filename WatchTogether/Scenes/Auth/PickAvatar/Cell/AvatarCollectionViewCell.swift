//
//  AvatarCollectionViewCell.swift
//  WatchTogether
//
//  Created by emin on 21.04.2021.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(avatarId: Int) {
        self.avatarImageView.image = UIImage.avatar(id: avatarId)
    }

}
