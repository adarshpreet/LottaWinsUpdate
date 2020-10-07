//
//  AllWinnerTableCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 17/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class AllWinnerTableCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView?
    @IBOutlet weak var lblAmount: UILabel?
    @IBOutlet weak var lblTier1: UILabel?
    @IBOutlet weak var lblTier2: UILabel?
    @IBOutlet weak var lblTier3: UILabel?
    @IBOutlet weak var lblTier4: UILabel?
    @IBOutlet weak var lblTier5: UILabel?
    
    @IBOutlet weak var lblWinnerNo: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    func setup() {
//        self.bgView?.layer.borderColor = UIColor("#322d55").cgColor
//        self.bgView?.layer.borderWidth = 1
//        self.bgView?.layer.cornerRadius = 10
        self.lblTier1?.layer.cornerRadius = 13
        self.lblTier2?.layer.cornerRadius = 13
        self.lblTier3?.layer.cornerRadius = 13
        self.lblTier4?.layer.cornerRadius = 13
        self.lblTier5?.layer.cornerRadius = 13
        self.lblWinnerNo?.layer.cornerRadius = 17
        
        self.lblTier1?.clipsToBounds = true
        self.lblTier2?.clipsToBounds = true
        self.lblTier3?.clipsToBounds = true
        self.lblTier4?.clipsToBounds = true
        self.lblTier5?.clipsToBounds = true
        self.bgView?.clipsToBounds = true
        self.lblWinnerNo?.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
