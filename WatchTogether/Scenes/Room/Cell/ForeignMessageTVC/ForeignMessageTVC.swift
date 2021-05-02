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
    
    func configureCell(avatarId: Int, text: String?, name: String?) {
        
        self.avatarView.image = UIImage.avatar(id: avatarId)
        let name = NSMutableAttributedString(string: (name ?? "") + ": ", attributes: [NSAttributedString.Key.font: R.font.kanitBold(size: 14)!])
        let text = NSMutableAttributedString(string: (text ?? ""), attributes: [NSAttributedString.Key.font: R.font.kanitLight(size: 14)!])
        name.append(text)
        
        self.messageLabel.attributedText = name
        
    }

}
