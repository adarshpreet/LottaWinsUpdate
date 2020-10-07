//
//  PastGiveawayCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 24/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PastGiveawayCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblUserNo: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblUserNo?.layer.cornerRadius = 22.5
              
              self.lblUserNo?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
