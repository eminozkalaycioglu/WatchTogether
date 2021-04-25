//
//  PickAvatarViewController.swift
//  WatchTogether
//
//  Created by emin on 21.04.2021.
//

import UIKit

protocol PickAvatarViewControllerDelegate: class {
    func pickAvatarViewControllerDidSelect(controller: PickAvatarViewController?, avatarId: Int)
    func pickAvatarViewControllerDidClose(controller: PickAvatarViewController?)
}

class PickAvatarViewController: WTViewController {
    
    weak var delegate: PickAvatarViewControllerDelegate?
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var avatarsCollectionView: UICollectionView! {
        didSet {
            avatarsCollectionView.delegate = self
            avatarsCollectionView.dataSource = self
            avatarsCollectionView.register(UINib(nibName: "AvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AvatarCollectionViewCell")
        }
    }
        
    var selectedAvatarId: Int? {
        didSet {
            if let id = self.selectedAvatarId, self.selectedImageView != nil {
                self.selectedImageView.image = UIImage.avatar(id: id)
            }
        }
    }
    
    override func setup() {
        super.setup()
        
        if let id = self.selectedAvatarId {
            self.selectedImageView.image =  UIImage.avatar(id: id)
        } else {
            self.selectedAvatarId = Int.random(in: 1..<(AppConstants.avatarCount+1))
        }
        
    }
    @IBAction func updateButtonTapAction(_ sender: Any) {
        
        if let id = self.selectedAvatarId {
            self.delegate?.pickAvatarViewControllerDidSelect(controller: self, avatarId: id)
        }
        
    }
    
    @IBAction func closeButtonTapAction(_ sender: Any) {
        self.delegate?.pickAvatarViewControllerDidClose(controller: self)
    }
}

extension PickAvatarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        AppConstants.avatarCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCollectionViewCell", for: indexPath) as! AvatarCollectionViewCell
        cell.configure(avatarId: indexPath.row + 1)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedAvatarId = indexPath.row + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
      
}

extension PickAvatarViewController {
    static func showOverCurrentContent(context: UIViewController, delegate: PickAvatarViewControllerDelegate, selectedAvatarId: Int) {
        
        let grayview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        grayview.tag = 3646
        grayview.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        context.view.addSubview(grayview)
        
        let vc = PickAvatarViewController()
        vc.selectedAvatarId = selectedAvatarId
        vc.delegate = delegate
        
        let navHeight = context.navigationController?.navigationBar.frame.height ?? 0
        let screenHeight = context.view.bounds.height
        
        
        let height: CGFloat = (screenHeight - navHeight) * 0.8
        
        vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: min(600.0, height))
        
        vc.view.center.x = context.view.center.x
        
        context.addChild(vc)
        grayview.addSubview(vc.view)
        
        
        DispatchQueue.main.async {
            vc.view.center.y = screenHeight * 1.5
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            UIView.animate(withDuration: 0.75, delay: 0, options: .layoutSubviews, animations: {
                vc.view.center.y = context.view.center.y + (navHeight / 1.5)
                vc.view.layoutIfNeeded()
            }, completion: nil)
        }
       
        vc.didMove(toParent: context)
    }
    
    static func hide(context: UIViewController, pickAvatarController: PickAvatarViewController?) {
    
        for vw in context.view.subviews {
            if vw.tag == 3646 {
                UIView.animate(withDuration: 0.75, delay: 0, options: .layoutSubviews, animations: {
                    pickAvatarController?.view.center.y = UIScreen.main.bounds.height + (pickAvatarController?.view.bounds.height ?? 0)/2
                    pickAvatarController?.view.layoutIfNeeded()
                }) { (_) in
                    vw.removeFromSuperview()
                }
                
            }
        }
        
        for child in context.children {
            if child.view.tag == 3646 {
                child.removeFromParent()
            }
        }
    }
}
