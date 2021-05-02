//
//  MoreUserCVC.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit

class MoreUserCVC: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(count: Int) {
        self.countLabel.text = "+\(count)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = self.bounds.height / 2
    }

}
