//
//  EnteredGiveawayVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 03/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import SDWebImage

class EnteredGiveawayVC: BaseViewController {

    @IBOutlet weak var giveAwayImgView: UIImageView?
    @IBOutlet weak var companyLogo: UIImageView?
    @IBOutlet weak var stackView: UIStackView?
    @IBOutlet weak var giveawayDateLbl: UILabel?
    @IBOutlet weak var enterDateLbl: UILabel?
    @IBOutlet weak var giveAwayType: UILabel!
    @IBOutlet weak var giveAwayPriceLabel: UILabel!

    var dataModel: CreateTicketModel?
    var giveAwayDetail: GiveAwayDetail?
    var singleGiveAway: GiveAwayListBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.giveAwayType.text = self.singleGiveAway?.type ?? ""
        self.companyLogo?.sd_setImage(with: URL(string: self.singleGiveAway?.winner_page_logo ?? ""), placeholderImage: UIImage(named: "group18"), options: .continueInBackground, context: nil)
    
        self.giveAwayImgView?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.giveAwayImgView?.sd_setImage(with: URL(string: self.singleGiveAway?.ticketImage?.image ?? ""), placeholderImage: UIImage(named: "group18"), options: .continueInBackground, context: nil)

        let formatter = DateFormatter()
        formatter.dateFormat = DateEnum.yyyyMMDD.rawValue
        let formatterISO = ISO8601DateFormatter()
        
        guard let startTime = self.singleGiveAway?.start_time else { return }
        let start_date = formatterISO.date(from: startTime)
        let currentDate = Date()
        formatter.dateFormat = DateEnum.edmYY.rawValue
        guard let convertedDate = start_date else { return }
                
        let dateString = formatter.string(from: convertedDate)
        self.giveawayDateLbl?.text = dateString
        
        let enterDate = formatter.string(from: currentDate)
        self.enterDateLbl?.text = enterDate
        
        let amountPrice =  Double(self.singleGiveAway?.prize_money ?? "0")?.removeZerosFromEnd()
//        self.giveAwayPriceLabel?.text =  "$" + "\(amountPrice ?? "0")"
        
        if let giveAway = self.singleGiveAway {
//            let type = giveAway.type ?? ""
            let prizeType = giveAway.prize_type ?? ""

            if prizeType == "Cash" {
//                self.giveAwayPriceLabel.isHidden = false
                self.companyLogo?.isHidden = true
            } else {
//                self.giveAwayPriceLabel.isHidden = true
                self.companyLogo?.isHidden = false
            }
        }
        
        let arrangedItem = self.stackView?.arrangedSubviews
        var i = 0
        for code in (self.dataModel?.code)! {
            if let button = arrangedItem?[i] as? UIButton {
                button.setTitle("\(code)", for: .normal)
                i = i+1
            }
        }
    }
    
    @IBAction func acnCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @IBAction func acnShare(_ sender: UIButton) {
        
        guard let imageURL = URL(string:self.singleGiveAway?.cover_image?.image ?? "") else { return }
        let items = ["Play live lottery and win cash, exclusive prizes", imageURL] as [Any]
        DispatchQueue.main.async {
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
        }
    }

    
    @IBAction func acnCreateAnotherTicket(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func acnBackToGiveaway(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
