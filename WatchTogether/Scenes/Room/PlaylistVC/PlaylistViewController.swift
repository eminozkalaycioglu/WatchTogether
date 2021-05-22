//
//  PlaylistViewController.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit

protocol PlaylistViewControllerDelegate: class {
    func playlistViewControllerShouldClose(_ controller: PlaylistViewController?)
    func playlistViewControllerDidSelectVideoToAdd(_ controller: PlaylistViewController?, id: String)
    func playlistViewControllerDidSelectVideoToPlay(_ controller: PlaylistViewController?, id: String)
    func playlistViewControllerDidSelectVideoToDelete(_ controller: PlaylistViewController?, id: String)

}

class PlaylistViewController: WTViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(cellType: PlaylistTVC.self)
        }
    }
    weak var delegate: PlaylistViewControllerDelegate?
    
    var viewModel: PlaylistViewModel!
    
    var canOpenWebView: Bool = false
    
    override func setup() {
        super.setup()
        self.viewModel.getPlaylist()
    }
    
    override func registerEvents() {
        super.registerEvents()
        
        self.viewModel.observePlaylist()
        self.viewModel.onFetchedPlaylist = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func closeButtonTapAction(_ sender: Any) {
        self.delegate?.playlistViewControllerShouldClose(self)
    }
    @IBAction func addButtonTapAction(_ sender: Any) {
        if self.canOpenWebView {
            let vc = SearchWebViewViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension PlaylistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.viewModel.playlist[indexPath.row]
        if let videoId = data.videoId {
            self.delegate?.playlistViewControllerDidSelectVideoToPlay(self, id: videoId)
        }
    }
}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: PlaylistTVC.self)
        
        let data = self.viewModel.playlist[indexPath.row]
        cell.configureCell(video: data)
        
        cell.onTappedDeleteButton = { [weak self] in
            if let videoId = data.videoId {
                self?.delegate?.playlistViewControllerDidSelectVideoToDelete(self, id: videoId)
            }
        }
        return cell
    }
}

extension PlaylistViewController: SearchWebViewViewControllerDelegate {
    func searchWebViewViewControllerDidSelectVideo(_ controller: SearchWebViewViewController?, id: String) {
        controller?.dismiss(animated: true, completion: nil)
        self.delegate?.playlistViewControllerDidSelectVideoToAdd(self, id: id)
    }
}

extension PlaylistViewController {
    static func showOverCurrentContent(context: UIViewController, delegate: PlaylistViewControllerDelegate, roomId: String, canOpenWebView: Bool) {
        
        let grayview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        grayview.tag = 364636
        grayview.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        context.view.addSubview(grayview)
        
        let vc = SF.makePlaylistVC(roomId: roomId, canOpenWebView: canOpenWebView)
        vc.delegate = delegate
        
        let navHeight = context.navigationController?.navigationBar.frame.height ?? 0
        let screenHeight = context.view.bounds.height
        
        let height: CGFloat = (screenHeight - navHeight) * 0.5
        
        vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.9, height: min(400, height))
        
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
    
    static func hide(context: UIViewController, playlistVC: PlaylistViewController?) {
    
        for vw in context.view.subviews {
            if vw.tag == 364636 {
                UIView.animate(withDuration: 0.75, delay: 0, options: .layoutSubviews, animations: {
                    playlistVC?.view.center.y = UIScreen.main.bounds.height + (playlistVC?.view.bounds.height ?? 0)/2
                    playlistVC?.view.layoutIfNeeded()
                }) { (_) in
                    vw.removeFromSuperview()
                }
                
            }
        }
        
        for child in context.children {
            if child.view.tag == 364636 {
                child.removeFromParent()
            }
        }
    }
}
