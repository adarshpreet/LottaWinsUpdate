//
//  PhotoUserNameCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PhotoUserNameCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: CustomImageView!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var avatarImgEdit: CustomButton!
    @IBOutlet weak var avatarUsernameEdit: CustomButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
