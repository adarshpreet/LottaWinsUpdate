//
//  NotificationCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var notificationSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
