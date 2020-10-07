//
//  LotteryChatPlayerView.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/10/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit


extension LotteryChatVC {
    
    func updateVolumeByAvatar() {
              
        self.onOffSound()
        Helper.shared.callBack = { [weak self] object in
            guard let self = `self` else { return }
            self.onOffSound()
        }
    }
       
   func onOffSound() {
       DispatchQueue.global(qos: .userInitiated).async {
           // do something
           let volume = Helper.shared.volumeSet
           self.videoPlayer?.player?.volume = volume
           DispatchQueue.main.async {
               if self.videoSoundButton != nil {
                    self.videoSoundButton.isSelected = volume > 0 ? true : false
               }
            }
        }
    }
    
    func playHorizontalCoverVideos() {
        self.updateVolumeByAvatar()
        self.setUpPlayerStatus()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.3)
        self.setVideo()
    }

    @objc func startLoading() {
        if self.presentedViewController != nil {
            return
        }
        // start loading video
        self.videoPlayer?.resume()
    }
    
    func setUpPlayerStatus() {
        self.videoPlayer?.getStatusBlock { [weak self] (status) in
           switch status {
           case .failed(let err):
               let alert = UIAlertController(title: "err", message: err.description, preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
               self?.present(alert, animated: true, completion: nil)
           case .ready:
               print("Ready to Play")
           case .playing:
               print("Playing")
           case .pause:
               print("Pause")
           case .end:
               print("End")
           default: break
           }
       }
    }
    
    /// Play Cover Video of Home Page And Also set the total view of count for Cover Video
      ///
      /// - Parameter indexPath:Cover Video Index Path
      func setVideo() {
          guard let giveAwayModel = self.viewModel.giveAwayDetail else { return }
          guard let coverImage = giveAwayModel.cover_image else { return }

          if let mediaURL = coverImage.image, mediaURL.isImage() == false {
                    
                //set view count for cover Video
                let volume = Helper.shared.volumeSet
                self.videoPlayer?.player?.volume = volume
                self.videoPlayer?.playView = self.backgrounImage
                self.videoPlayer?.thumbImageView.image = self.backgrounImage.image
                self.videoPlayer?.set(url: URL(string: mediaURL)!)
                self.videoPlayer?.player?.play()
                self.videoPlayer?.isPauseVideo = false
                self.videoPlayer?.resume()
          } else {
            self.stopPlayer()
         }
    }
    
    func stopPlayer() {
        self.videoPlayer?.isPauseVideo = true
        self.videoPlayer?.player?.pause()
    }
    
    //Put Volume on and off for the player
    @IBAction func volumeOnOff(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        Helper.shared.volumeSet = sender.isSelected == true ? 1 : 0
        self.videoPlayer?.player?.volume = Helper.shared.volumeSet
    }
}
