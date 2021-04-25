//
//  RoomViewController.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import UIKit

class RoomViewController: WTViewController {
    
    var viewModel: RoomViewModel!
    
    @IBOutlet weak var testTable: UITableView! {
        didSet {
            testTable.delegate = self
            testTable.dataSource = self
            testTable.register(UINib(nibName: "MyMessageTVC", bundle: nil), forCellReuseIdentifier: "MyMessageTVC")
           
        }
    }
    @IBOutlet weak var testField: UITextField!
    override func setup() {
        super.setup()
        navigation.item.titleView = nil
        navigation.bar.barTintColor = R.color.mainBlueColorDark()!
        
        
    }

    
    override func registerEvents() {
        super.registerEvents()
        self.viewModel.observeMessages()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTVC", for: indexPath) as! MyMessageTVC
        let data = self.viewModel.messages[indexPath.row]
        cell.configureCell(avatarId: 1, text: data.text)
        return cell
    }
    
    
}
