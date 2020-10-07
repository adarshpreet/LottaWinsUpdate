//
//  LotteryHomeVCHelper.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/9/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit


extension LotteryHomeVC {
    
    func updateVolumeByAvatar() {
           
       self.updateVolumeButtonInCell()
       Helper.shared.callBack = { [weak self] object in
           guard let self = `self` else { return }
           self.updateVolumeButtonInCell()
       }
    }
    
    func updateVolumeButtonInCell() {
        DispatchQueue.global(qos: .userInitiated).async {
            // do something
            let volume = Helper.shared.volumeSet
            self.videoPlayer?.player?.volume = volume
            DispatchQueue.main.async {
                if self.giveAwayCollection != nil {
                    
                     if let centerCellIndexPath: IndexPath  = self.giveAwayCollection!.centerCellIndexPath {
                         if let cell = self.getVideoCell(at: centerCellIndexPath) {
                             cell.videoSoundButton.isSelected = volume > 0 ? true : false
                         }
                     }
                }
            }
        }
    }
    
    func setCollectionObserver() {
        self.setUpPlayerStatus()
        self.offsetObservation = self.giveAwayCollection!.observe(\.contentOffset, options: [.new]) { [weak self] (_, value) in
            guard let self = `self`, self.presentedViewController == nil else { return }
            self.playHorizontalCoverVideos()
        }
    }
    
    func playHorizontalCoverVideos() {
        if self.viewModel.listData.count > 0 {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(self.startLoading), with: nil, afterDelay: 0.3)
            if let centerCellIndexPath: IndexPath  = self.giveAwayCollection!.centerCellIndexPath {
                self.updateCell(at: centerCellIndexPath)
            }
        }
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
       func updateCell(at indexPath: IndexPath) {
           let VideoData = self.viewModel.listData[indexPath.row]
           guard let coverImage = VideoData.cover_image else { return }
            guard self.isPlayVideo else {
                self.stopPlayer()
                return
            }
           if let mediaURL = coverImage.image, mediaURL.isImage() == false {
              if let cell = self.getVideoCell(at: indexPath) {
                 //set view count for cover Video
                 let volume = Helper.shared.volumeSet
                 self.videoPlayer?.player?.volume = volume
                 cell.videoSoundButton.isSelected = volume > 0 ? true : false
                 self.videoPlayer?.playView = cell.backgroundImgView
                 self.videoPlayer?.thumbImageView.image = cell.backgroundImgView?.image
                 self.videoPlayer?.set(url: URL(string: mediaURL)!)
                 self.videoPlayer?.player?.play()
                 self.videoPlayer?.isPauseVideo = false
                 self.videoPlayer?.resume()
              }
           } else {
              self.stopPlayer()
          }
    }
    
    var isPlayVideo: Bool {
        let count = self.navigationController?.viewControllers.count ?? 0
        return count > 1 ? false : true
    }
    
    func stopPlayer() {
        self.videoPlayer?.isPauseVideo = true
        self.videoPlayer?.player?.pause()
    }
    
    func getVideoCell(at indexPath: IndexPath) -> GiveAwayCollectionCell? {
       if let cell = self.giveAwayCollection!.cellForItem(at: indexPath) as? GiveAwayCollectionCell {
           return cell
       }
       return nil
    }
    
    //Put Volume on and off for the player
    @objc func volumeOnOff(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        Helper.shared.volumeSet = sender.isSelected == true ? 1 : 0
        self.videoPlayer?.player?.volume = Helper.shared.volumeSet
    }
}
