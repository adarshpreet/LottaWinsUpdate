//
//  MyTicketsNumberCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 05/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class MyTicketsNumberCell: UITableViewCell {

    @IBOutlet weak var ticketNumberLbl: UILabel?
    @IBOutlet weak var dateLbl: UILabel?
    @IBOutlet weak var bgImgView: UIImageView?
    
    @IBOutlet weak var ticket1: UILabel!
    @IBOutlet weak var ticket2: UILabel!
    @IBOutlet weak var ticket3: UILabel!
    @IBOutlet weak var ticket4: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(_ number: [Int], _ date: String) {
        let formattedString = (number.map{String($0)}).joined(separator: "  ")
        print("formattedArrays \(formattedString)")
        self.ticket1?.text = String(number[0])
        self.ticket2?.text = String(number[1])
        self.ticket3?.text = String(number[2])
        self.ticket4?.text = String(number[3])
        self.ticketNumberLbl?.text = String(number[4])
        self.ticket1.layer.cornerRadius = self.ticket1.frame.height/2
        self.ticket1.clipsToBounds = true
        self.ticket2.layer.cornerRadius = self.ticket2.frame.height/2
               self.ticket2.clipsToBounds = true
        self.ticket3.layer.cornerRadius = self.ticket3.frame.height/2
               self.ticket3.clipsToBounds = true
        self.ticket4.layer.cornerRadius = self.ticket4.frame.height/2
               self.ticket4.clipsToBounds = true
        self.ticketNumberLbl?.layer.cornerRadius = (self.ticketNumberLbl?.frame.height)!/2
        self.ticketNumberLbl?.clipsToBounds = true
        self.dateLbl?.text = date
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

