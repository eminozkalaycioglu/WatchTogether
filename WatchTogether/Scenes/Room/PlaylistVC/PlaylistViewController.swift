//
//  PlaylistViewController.swift
//  WatchTogether
//
//  Created by emin on 2.05.2021.
//

import UIKit

protocol PlaylistViewControllerDelegate: class {
    func playlistViewControllerShouldClose(_ controller: PlaylistViewController?)
}

class PlaylistViewController: WTViewController {

    weak var delegate: PlaylistViewControllerDelegate?
    
    var viewModel: PlaylistViewModel!
    
    override func setup() {
        super.setup()
    }

    @IBAction func closeButtonTapAction(_ sender: Any) {
        self.delegate?.playlistViewControllerShouldClose(self)
    }
    @IBAction func addButtonTapAction(_ sender: Any) {
        let vc = SearchWebViewViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PlaylistViewController: SearchWebViewViewControllerDelegate {
    func searchWebViewViewControllerDidSelectVideo(_ controller: SearchWebViewViewController?, id: String) {
        controller?.navigationController?.popViewController(animated: true)
        WTAlert.show(self, title: "Video ID", message: id, buttons: nil)
        YoutubeServices().getVideoDetail(id) { (result) in
            switch result {
            case let .success(videoDetail):
                let item = videoDetail.items.first
                let video = Video(
                    videoId: id,
                    title: item?.snippet.title,
                    thumbnail: item?.snippet.thumbnails.defaultField.url,
                    channel: item?.snippet.channelTitle,
                    duration: 0)
                
//                WTFirebaseManager.shared.addVideoToRoomPlaylist(roomId: "9E4F43BC-791C-4D64-9048-3104C9F7F7E2", video: video) { (_) in
//
//                }
            case .failure:
                break
            }
        }
    }
}

extension PlaylistViewController {
    static func showOverCurrentContent(context: UIViewController, delegate: PlaylistViewControllerDelegate, playlist: [Video]) {
        
        let grayview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        grayview.tag = 364636
        grayview.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        context.view.addSubview(grayview)
        
        let vc = SF.makePlaylistVC(playlist: playlist)
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
            if child.view.tag == 3646 {
                child.removeFromParent()
            }
        }
    }
}

class PlaylistViewModel: BaseViewModel {
    private var playlist: [Video]
    
    init(playlist: [Video]) {
        self.playlist = playlist
    }
}



