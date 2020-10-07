//
//  MyCoinsCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class MyCoinsCell: UITableViewCell {

    @IBOutlet weak var viewCoins: EditingView!
    @IBOutlet weak var shareCodeBtn: CustomButton!
    @IBOutlet weak var coinsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
               self.viewCoins?.clipsToBounds = true
               self.viewCoins?.layer.cornerRadius = 20
               self.viewCoins?.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
