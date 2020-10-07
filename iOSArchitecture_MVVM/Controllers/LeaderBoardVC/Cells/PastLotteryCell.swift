//
//  PastLotteryCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 24/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PastLotteryCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblNo1: UILabel?
    @IBOutlet weak var lblNo2: UILabel?
    @IBOutlet weak var lblNo3: UILabel?
    @IBOutlet weak var lblNo4: UILabel?
    @IBOutlet weak var lblNo5: UILabel?
    @IBOutlet weak var lblUserNo: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup() {
        
        self.lblNo1?.layer.cornerRadius = 15
        self.lblNo2?.layer.cornerRadius = 15
        self.lblNo3?.layer.cornerRadius = 15
        self.lblNo4?.layer.cornerRadius = 15
        self.lblNo5?.layer.cornerRadius = 15
        self.lblUserNo?.layer.cornerRadius = 22.5
        
        self.lblNo1?.clipsToBounds = true
        self.lblNo2?.clipsToBounds = true
        self.lblNo3?.clipsToBounds = true
        self.lblNo4?.clipsToBounds = true
        self.lblNo5?.clipsToBounds = true
        self.lblUserNo?.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
