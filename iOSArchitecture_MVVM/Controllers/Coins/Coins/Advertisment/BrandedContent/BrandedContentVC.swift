//
//  BrandedContentVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 22/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import AVKit

class BrandedContentVC: BaseViewController {

    @IBOutlet weak var viewLayerView: UIView!
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    var model: SponsoredContent?
    var onMessage: SwiftCallBacks.handler?
    var isVideoComplete = false
    
    // MARK:- View Life Cycle Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startVideo()
    }
    
    func startVideo() {
        guard let sponsoredModel = self.model else { return }
        guard let url = URL(string: sponsoredModel.file ?? "") else { return }

        self.player = AVPlayer(url: url)
        self.addObservers()
        self.avPlayerLayer = AVPlayerLayer(player: player)
        self.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.viewLayerView.layer.addSublayer(avPlayerLayer)
        self.playVideo()
    }
    
    func addObservers() {
        // We are adding the observer to get the status when video is watch completely.
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.isVideoComplete = true
        self.dismissScreen()
    }
    
    @IBAction func closeAdView(_ sender: UIButton) {
        self.dismissScreen()
    }
    
    func dismissScreen() {
       self.onMessage?(self.isVideoComplete)
       self.dismiss(animated: true) {
           // Increase coins
       }
    }
    
    override func viewDidLayoutSubviews() {
        self.avPlayerLayer.frame = self.viewLayerView.layer.bounds
    }
    
    private func playVideo() {
        player.play()
    }
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


