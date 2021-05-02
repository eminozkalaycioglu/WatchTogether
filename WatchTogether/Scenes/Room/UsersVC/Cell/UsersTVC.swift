//
//  UsersTVC.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit

class UsersTVC: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteUserButton: UIButton!
    
    var onDeleteButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 20
    }
    
    func configureCell(avatarId: Int, name: String?, canDelete: Bool) {
        self.avatarImageView.image = UIImage.avatar(id: avatarId)
        self.nameLabel.text = name
        self.deleteUserButton.isHidden = !canDelete
    }
    
    @IBAction func deleteUserButtonTapAction(_ sender: Any) {
        self.onDeleteButtonTapped?()
    }
}
