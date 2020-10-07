//
//  GiveAwayCollectionCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 26/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

protocol GiveAwayCellDelegate {
    func enterGiveAway(tag: Int)
    func shareGiveAway(tag: Int)
    func tapOnSeeChat(tag: Int)
}

class GiveAwayCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var backgroundImgView: UIImageView?
    @IBOutlet weak var logoView: UIImageView?
    @IBOutlet weak var amountLbl: UILabel?
    @IBOutlet weak var startTimeLbl: UILabel?
    @IBOutlet weak var airingButton: UIButton?
    @IBOutlet weak var share: UIButton?
    @IBOutlet weak var adultLogo: UIImageView?
    @IBOutlet weak var videoSoundButton: UIButton!
    @IBOutlet weak var enterGiveAway: CustomButton!

    var delegate: GiveAwayCellDelegate?
    var dataModel: GiveAwayListBase?
    
    
    // MARK:- Set UP Cell
    func setupCell(_ data: GiveAwayListBase) {
        
        let isShow = data.is_prize_amount_hidden ?? false
        
        let amountPrice =  Double(data.prize_money ?? "0")?.removeZerosFromEnd()
//        self.amountLbl?.text =  "$" + "\(amountPrice ?? "")"
        
//        self.amountLbl?.isHidden = !isShow
        
        guard let coverImage = data.cover_image else { return }

        if let mediaURL = coverImage.image {
            if mediaURL.isImage() {
                self.backgroundImgView?.sd_setImage(with: URL(string: mediaURL), completed: { (image, error, none, imgURL) in
                    
                    guard error == nil else {
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    self.backgroundImgView?.image = image
                })
            } else {
                self.backgroundImgView?.sd_setImage(with: URL(string: coverImage.thumbnail ?? ""), placeholderImage: nil, options: .continueInBackground, context: nil)
            }
        }
        
        self.logoView?.sd_setImage(with: URL(string: data.client?.company_logo ?? ""), placeholderImage: UIImage(named: "Welcome_logo"), options: .continueInBackground, context: nil)
        
        let type = data.type ?? ""
        self.enterGiveAway.setTitle("Enter \(type)", for: .normal)

        let formatter = DateFormatter()
        formatter.dateFormat = DateEnum.yyyyMMDD.rawValue
        let formatterISO = ISO8601DateFormatter()
        guard let startTime = data.end_time else { return }
        let start_date = formatterISO.date(from: startTime)
        let currentDate = Date()
        let hourDiff = Calendar.current.dateComponents([.hour], from: currentDate, to: start_date ?? Date()).hour ?? 0
        formatter.dateFormat = DateEnum.edmYYYY.rawValue
        guard let convertedDate = start_date else { return }
        
        let dateString = formatter.string(from: convertedDate)
        self.startTimeLbl?.text = dateString + " PST"
        
        if hourDiff <= 2 {
            airingButton?.isHidden = false
        } else {
            airingButton?.isHidden = true
        }
    }
    
    @IBAction func enterGiveAway(_ sender: UIButton) {
        self.delegate?.enterGiveAway(tag: self.share?.tag ?? 0)
    }
    
    @IBAction func share(_ sender: UIButton) {
        self.delegate?.shareGiveAway(tag: self.share?.tag ?? 0)
    }
    
    @IBAction func tapOnSeeChat(_ sender: UIButton) {
        self.delegate?.tapOnSeeChat(tag: self.share?.tag ?? 0)
    }
    
}
