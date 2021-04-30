//
//  RoomViewController.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import UIKit
import PopupDialog

class RoomViewController: WTViewController {
    
    var viewModel: RoomViewModel!
    
    @IBOutlet weak var testTable: UITableView! {
        didSet {
            testTable.delegate = self
            testTable.dataSource = self
            testTable.register(UINib(nibName: "MyMessageTVC", bundle: nil), forCellReuseIdentifier: "MyMessageTVC")
            testTable.register(UINib(nibName: "ForeignMessageTVC", bundle: nil), forCellReuseIdentifier: "ForeignMessageTVC")
        }
    }
    
    @IBOutlet weak var testField: UITextField!
    override func setup() {
        super.setup()
        navigation.item.titleView = nil
        navigation.bar.barTintColor = R.color.mainBlueColorDark()!
        
        
        navigation.item.leftBarButtonItem = UIBarButtonItem(
            image: R.image.backIcon()!,
            style: .plain,
            target: self,
            action: #selector(self.onTapBack))
        
    }
    
    @objc
    private func onTapBack() {
        let cancel = CancelButton(title: "Hayır", action: nil)
        let ok = DefaultButton(title: "Evet") {
            self.viewModel.exitRoom { [weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }
        }
        WTAlert.show(self, title: "Uyarı", message: "Odadan Çıkmak İstiyor musunuz?", buttons: [cancel, ok])
        
    }
    
    override func registerEvents() {
        super.registerEvents()
        
        self.viewModel.observeMessages()
        self.viewModel.observeRoomDeleting()
        self.viewModel.fetchUserInfos()
        
        self.viewModel.onNewMessagesReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.testTable.reloadData()
                let count = self?.viewModel.messages.count ?? 0
                self?.testTable.scrollToRow(
                    at: IndexPath(row: max(count - 1, 0), section: 0),
                    at: .bottom,
                    animated: true)
            }
        }
        
        self.viewModel.onShouldBackToTabBar = { [weak self] in
            DispatchQueue.main.async {
                self?.router.setRootViewController(SF.makeMainTabBar())
            }
        }
    }
    
    @IBAction func testbuttontap(_ sender: Any) {
        guard let messageText = self.testField.text else { return }
        self.viewModel.sendMessage(text: messageText)
    }
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.viewModel.messages[indexPath.row]
        let avatarId = self.viewModel.getAvatarIdFrom(ownerId: data.ownerId ?? "")
        if self.viewModel.isMyMessage(data) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTVC", for: indexPath) as! MyMessageTVC
            cell.configureCell(avatarId: avatarId, text: data.text)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForeignMessageTVC", for: indexPath) as! ForeignMessageTVC
            cell.configureCell(avatarId: avatarId, text: data.text)
            return cell
        }
        
        
    }
    
    
}
