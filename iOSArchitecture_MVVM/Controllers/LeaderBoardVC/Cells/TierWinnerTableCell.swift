//
//  TierWinnerTableCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 24/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class TierWinnerTableCell: UITableViewCell {

    @IBOutlet weak var profileImgView: UIImageView?
    @IBOutlet weak var lblName: UILabel?
    @IBOutlet weak var lblAmount: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup() {
        
        self.lblAmount?.layer.cornerRadius = 20
        self.lblAmount?.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
