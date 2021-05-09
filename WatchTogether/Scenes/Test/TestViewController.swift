//
//  TestViewController.swift
//  WatchTogether
//
//  Created by emin on 18.04.2021.
//

import UIKit
import youtube_ios_player_helper

class TestViewController: UIViewController {

    private let playerVars = [
        "modestbranding": "0", //
        "playsinline": "1", //
        "fs": "1", //
        "controls": "0", //
        "rel": "0",
        "enablejsapi": "0"
    ]
    
    var startSec: Float = 0
    @IBOutlet weak var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        self.loadWithCurrentTime(id: "WGRuxlH-X9w", currentTime: 12)
//        self.playerView.loadVideo(byId: "D_3x_QIr76U", startSeconds: Float(10.0))
//        self.playerView.load(withVideoId: "D_3x_QIr76U")
//        self.playerView.delegate = self
//        self.playerView.seek(toSeconds: 10, allowSeekAhead: true)
//        self.playerView.cueVideo(byId: "D_3x_QIr76U", startSeconds: 10.0)

    }
    
    func loadWithCurrentTime(id: String, currentTime: Float) {
        self.startSec = currentTime
        self.playerView.load(withVideoId: id, playerVars: self.playerVars)
    }
}

extension TestViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
        if self.startSec != 0 {
            self.playerView.seek(toSeconds: self.startSec, allowSeekAhead: true)
        }
        self.startSec = 0
    }
}
 
