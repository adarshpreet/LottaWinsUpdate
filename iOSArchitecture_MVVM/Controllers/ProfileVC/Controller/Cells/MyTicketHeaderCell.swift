//
//  MyTicketHeaderCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 05/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class MyTicketHeaderCell: UITableViewCell {

    @IBOutlet weak var companyLogoImgView: UIImageView?
    @IBOutlet weak var amountLbl: UILabel?
    @IBOutlet weak var dateLbl: UILabel?
    
    func setupCell(_ dataModel: AllGeneratedTickets) {
        self.companyLogoImgView?.image = UIImage(named: "")
//        self.amountLbl?.text = "$\(dataModel.prize ?? "0")"
        self.dateLbl?.text = dataModel.end_date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
