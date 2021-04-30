//
//  ForeignMessageTVC.swift
//  WatchTogether
//
//  Created by emin on 30.04.2021.
//

import UIKit

class ForeignMessageTVC: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stackView.layer.cornerRadius = 20
    }
    
    func configureCell(avatarId: Int, text: String?) {
        self.avatarView.image = UIImage.avatar(id: avatarId)
        self.messageLabel.text = text
    }

}
