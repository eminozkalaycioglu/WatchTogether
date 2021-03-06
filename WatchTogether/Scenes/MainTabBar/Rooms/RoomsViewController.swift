//
//  RoomsViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit

class RoomsViewController: WTViewController {

    @IBOutlet weak var roomsTableView: UITableView! {
        didSet {
            roomsTableView.register(UINib(nibName: "RoomTVC", bundle: nil), forCellReuseIdentifier: "RoomTVC")
            roomsTableView.dataSource = self
            roomsTableView.delegate = self
            roomsTableView.contentInset.top = 8
            
            refreshControl.attributedTitle = NSAttributedString(string: "Yenile")
            refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
            roomsTableView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var roomTypeSelectionView: RoomTypeSelectionView! {
        didSet {
            roomTypeSelectionView.commonInit()
            roomTypeSelectionView.delegate = self
        }
    }
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = R.color.whiteAlpha075()!
        return refreshControl
    }()
    
    var viewModel: RoomsViewModel!

    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.observeRooms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchRooms()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.removeRoomObservers()
    }
    
    override func registerEvents() {
        super.registerEvents()
        self.viewModel.onFetchedRooms = { [weak self] in
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.refreshControl.endRefreshing()
                }
                self?.roomsTableView.reloadData()
            }
        }
        
        self.viewModel.onChangedRoomType = { [weak self] in
            DispatchQueue.main.async {
                self?.roomsTableView.reloadData()
            }
        }
        
        self.viewModel.onJoinedRoom = { [weak self] roomId in
            DispatchQueue.main.async {
                guard let roomId = roomId else { return }
                let vc = SF.makeRoomVC(roomId: roomId)
                self?.navigationController?.pushViewController(vc, animated: true)

            }
        }
        
    }
    
    @objc
    private func refresh(_ sender: AnyObject) {
        self.viewModel.fetchRooms()
    }
}

extension RoomsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTVC", for: indexPath) as! RoomTVC
        let data = self.viewModel.rooms[indexPath.row]
        cell.configureCell(room: data)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.rooms.count
    }
    
}

extension RoomsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? RoomTVC
        cell?.roomNameLabel.restartLabel()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.viewModel.roomType {
        case .private:
            EnterPasswordViewController.showOverCurrentContent(context: self, delegate: self, selectedIndex: indexPath.row)
        case .public:
            self.viewModel.joinRoom(index: indexPath.row, password: nil)

        }
        
    }

}

extension RoomsViewController: RoomTypeSelectionViewDelegate {
    func roomTypeSelectionViewDidSelect(_ view: RoomTypeSelectionView?, selection: RoomType) {
        print("emintest: ", selection)
        self.viewModel.roomType = selection
    }
}

extension RoomsViewController: EnterPasswordViewDelegate {
    func enterPasswordViewControllerDidEnterPassword(_ controller: EnterPasswordViewController?, password: String, selectedIndex: Int) {
        self.viewModel.joinRoom(index: selectedIndex, password: password)
    }
    
    func enterPasswordViewControllerShouldClose(_ controller: EnterPasswordViewController?) {
        EnterPasswordViewController.hide(context: self, passwordVC: controller)
    }
    
    
}
