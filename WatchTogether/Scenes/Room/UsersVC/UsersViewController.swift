//
//  UsersViewController.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit

protocol UsersViewControllerDelegate: class {
    func usersViewControllerShouldClose(_ controller: UsersViewController?)
}

class UsersViewController: WTViewController {
    
    weak var delegate: UsersViewControllerDelegate?
    
    var viewModel: UsersViewModel!

    @IBOutlet weak var usersTableView: UITableView! {
        didSet {
            usersTableView.dataSource = self
            usersTableView.register(UINib(nibName: "UsersTVC", bundle: nil), forCellReuseIdentifier: "UsersTVC")
        }
    }
    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
    }
    
    override func registerEvents() {
        super.registerEvents()
        
        self.viewModel.onUserDeleted = { [weak self] in
            self?.delegate?.usersViewControllerShouldClose(self)
        }
    }
    
    @IBAction func closeButtonTapAction(_ sender: Any) {
        self.delegate?.usersViewControllerShouldClose(self)
    }
}

extension UsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTVC", for: indexPath) as! UsersTVC
        let data = self.viewModel.users[indexPath.row]
        cell.configureCell(avatarId: data.avatarId ?? 999, name: data.fullName, canDelete: self.viewModel.canDelete && (data.userId != self.viewModel.userId))
        
        cell.onDeleteButtonTapped = { [weak self] in
            self?.viewModel.deleteUser(uid: data.userId ?? "")
        }
        
        return cell
    }
}

extension UsersViewController {
    static func showOverCurrentContent(context: UIViewController, delegate: UsersViewControllerDelegate, users: [WTUser], roomId: String, userId: String, canDelete: Bool) {
        
        let grayview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        grayview.tag = 3646
        grayview.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        context.view.addSubview(grayview)
        
        let vc = SF.makeUsersVC(users: users, roomId: roomId, userId: userId, canDelete: canDelete)
        vc.delegate = delegate
        
        let navHeight = context.navigationController?.navigationBar.frame.height ?? 0
        let screenHeight = context.view.bounds.height
        
        let height: CGFloat = (screenHeight - navHeight) * 0.5
        
        vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.8, height: min(400, height))
        
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
    
    static func hide(context: UIViewController, usersVC: UsersViewController?) {
    
        for vw in context.view.subviews {
            if vw.tag == 3646 {
                UIView.animate(withDuration: 0.75, delay: 0, options: .layoutSubviews, animations: {
                    usersVC?.view.center.y = UIScreen.main.bounds.height + (usersVC?.view.bounds.height ?? 0)/2
                    usersVC?.view.layoutIfNeeded()
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

