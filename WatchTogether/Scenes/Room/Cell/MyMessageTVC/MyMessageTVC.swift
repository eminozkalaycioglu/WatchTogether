//
//  MyMessageTVC.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import UIKit

class MyMessageTVC: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.stackView.layer.cornerRadius = 20
    }

    func configureCell(avatarId: Int, text: String?) {
        self.avatarImageView.image = UIImage.avatar(id: avatarId)
        self.messageText.text = text
    }
    
}
