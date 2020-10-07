//
//  ChatCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/5/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var avtarMessage: UILabel!
    @IBOutlet weak var avtarImage: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
