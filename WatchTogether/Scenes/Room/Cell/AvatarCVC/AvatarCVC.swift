//
//  AvatarCVC.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit

class AvatarCVC: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(avatarId: Int) {
        self.avatarImageView.image = UIImage.avatar(id: avatarId)
    }

}
