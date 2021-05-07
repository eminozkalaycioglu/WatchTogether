//
//  RoomViewController.swift
//  WatchTogether
//
//  Created by emin on 26.04.2021.
//

import UIKit
import PopupDialog
import youtube_ios_player_helper

class RoomViewController: WTViewController {
    
    var viewModel: RoomViewModel!
    private let playerVars = [
        "modestbranding": "0", //
        "playsinline": "1", //
        "fs": "1", //
        "controls": "0", //
        "rel": "0",
        "enablejsapi": "0"
    ]
    
    @IBOutlet weak var playerView: YTPlayerView! {
        didSet {
            playerView.delegate = self
        }
    }
    
    @IBOutlet weak var usersCollectionView: UICollectionView! {
        didSet {
            usersCollectionView.dataSource = self
            usersCollectionView.delegate = self
            usersCollectionView.register(UINib(nibName: "AvatarCVC", bundle: nil), forCellWithReuseIdentifier: "AvatarCVC")
            usersCollectionView.register(UINib(nibName: "MoreUserCVC", bundle: nil), forCellWithReuseIdentifier: "MoreUserCVC")
            
            usersCollectionView.backgroundColor = R.color.cardBackgroundColor()!
            usersCollectionView.clipsToBounds = true
            usersCollectionView.layer.cornerRadius = 20
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
            usersCollectionView.collectionViewLayout = layout
            
            usersCollectionView.contentInset.left = 6
            usersCollectionView.contentInset.right = 6
        }
    }
    
    @IBOutlet weak var usersCollectionViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var testTable: UITableView! {
        didSet {
            testTable.delegate = self
            testTable.dataSource = self
            testTable.register(UINib(nibName: "MyMessageTVC", bundle: nil), forCellReuseIdentifier: "MyMessageTVC")
            testTable.register(UINib(nibName: "ForeignMessageTVC", bundle: nil), forCellReuseIdentifier: "ForeignMessageTVC")
        }
    }
    
    @IBOutlet weak var testField: MessageTextField!
    @IBOutlet weak var controlView: GradientView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func setup() {
        super.setup()
        self.registerLoadableViewModel(viewModel: self.viewModel)
        navigation.item.titleView = nil
        navigation.bar.barTintColor = R.color.mainBlueColorDark()!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.addVideoToPlaylist(id: "mL2bHLXrjLQ")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                self.viewModel.addVideoToPlaylist(id: "-bu07lgylek")
            }
            
        }
        
        navigation.item.leftBarButtonItem = UIBarButtonItem(
            image: R.image.backIcon()!,
            style: .plain,
            target: self,
            action: #selector(self.onTapBack))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onUsersCollectionViewTapAction))
        self.usersCollectionView.addGestureRecognizer(gesture)
                
    }
    
    @objc
    private func onUsersCollectionViewTapAction() {
        
        UsersViewController.showOverCurrentContent(
            context: self,
            delegate: self,
            users: self.viewModel.currentUsers,
            roomId: self.viewModel.roomId,
            userId: self.viewModel.getUserID(),
            canDelete: self.viewModel.currentUserIsOwner())
        
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
        
        self.viewModel.fetchRoom()
        self.viewModel.observeMessages()
        self.viewModel.observeRoomUsers()
        
        self.viewModel.observeContent()
        
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
        
        self.viewModel.onContentChanged = { [weak self] content in
            guard let videoID = content.video?.videoId else { return }
            if self?.lastVideoID != videoID {
                self?.playVideo(id: videoID)
            } else {
                
            }
        }
        
        self.viewModel.onFetchedUserInfos = { [weak self] in
            DispatchQueue.main.async {
                self?.testTable.reloadData()
                self?.usersCollectionView.reloadData()
                self?.controlView.isHidden = !(self?.viewModel.currentUserIsOwner() ?? false)
            }
        }
        
        self.viewModel.onUsersChanged = { [weak self] in
            
        }
        
        self.viewModel.onShouldStartVideo = { [weak self] videoId in
            DispatchQueue.main.async {
                self?.playVideo(id: videoId)
            }
        }
    }
    
    
    var lastVideoID: String = ""
    func playVideo(id: String) {
        self.playerView.load(withVideoId: id, playerVars: self.playerVars)
        self.lastVideoID = id
        //TODO content dğeiştirme fonksiyonu
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.observeRoomDeleting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.removeRoomObservers()
    }
    
    @IBAction func testbuttontap(_ sender: Any) {
        guard let messageText = self.testField.text,
              messageText.count > 0 else { return }
        self.viewModel.sendMessage(text: messageText)
        self.testField.text?.removeAll()
    }
    
    @IBAction func playlistButtonTapAction(_ sender: Any) {
        PlaylistViewController.showOverCurrentContent(context: self, delegate: self, roomId: self.viewModel.roomId)
    }
    
    @IBAction func playPauseButtonTapAction(_ sender: Any) {
        self.playerView.playerState { (state, _) in
            switch state {
            case .playing:
                self.playerView.pauseVideo()
            case .paused:
                self.playerView.playVideo()
            default: break
            }
        }
    }
}

extension RoomViewController: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case .playing:
            self.playPauseButton.setTitle("Durdur", for: .normal)
        case .paused:
            self.playPauseButton.setTitle("Başlat", for: .normal)
        case .ended:
            print("emintest ended")
            self.viewModel.manageNextVideo { [weak self] (video) in
                guard let video = video else { return }
                print("emintest addContent")

                self?.viewModel.addContentToRoom(video: video)
            }
        default: break
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
}


//MARK: - Table View Delegate & Data Source
extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.viewModel.messages[indexPath.row]
        let avatarId = self.viewModel.getAvatarIdFrom(ownerId: data.ownerId ?? "")
        let name = self.viewModel.getNameFrom(ownerId: data.ownerId ?? "")
        if self.viewModel.isMyMessage(data) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTVC", for: indexPath) as! MyMessageTVC
            cell.configureCell(avatarId: avatarId, text: data.text)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForeignMessageTVC", for: indexPath) as! ForeignMessageTVC
            cell.configureCell(avatarId: avatarId, text: data.text, name: name)
            return cell
        }
    }
}

//MARK: - Collection View Delegate & Data Source
extension RoomViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row <= 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCVC", for: indexPath) as! AvatarCVC
            let avatarId = self.viewModel.currentUsers[indexPath.row].avatarId ?? 999
            cell.configureCell(avatarId: avatarId)
            return cell

        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreUserCVC", for: indexPath) as! MoreUserCVC
            let count = self.viewModel.currentUsers.count - 4
            cell.configureCell(count: count)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.viewModel.currentUsers.count > 4 {
            self.setCollectionViewWidth(cellCount: 5)
            return 5
        } else {
            self.setCollectionViewWidth(cellCount: self.viewModel.currentUsers.count)
            return self.viewModel.currentUsers.count
        }
        
    }
    
    private func setCollectionViewWidth(cellCount: Int) {
        self.usersCollectionViewWidth.constant = CGFloat(40 * cellCount) + 12.0
        self.view.layoutIfNeeded()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 30, height: 30)
    }
    
}


extension RoomViewController: UsersViewControllerDelegate {
    func usersViewControllerShouldClose(_ controller: UsersViewController?) {
        UsersViewController.hide(context: self, usersVC: controller)
    }
}

extension RoomViewController: PlaylistViewControllerDelegate {
    func playlistViewControllerShouldClose(_ controller: PlaylistViewController?) {
        PlaylistViewController.hide(context: self, playlistVC: controller)
    }
    
    func playlistViewControllerDidSelectVideo(_ controller: PlaylistViewController?, id: String) {
//        PlaylistViewController.hide(context: self, playlistVC: controller)
        self.viewModel.addVideoToPlaylist(id: id)
    }
}
