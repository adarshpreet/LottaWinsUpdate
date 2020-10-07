//
//  AgeConfirmationPopup.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 21/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

protocol AgeConfirmationProtocol {
    func ageConfirmation(tag: Int)
}

class AgeConfirmationPopup: UIViewController {

    @IBOutlet weak var popView: UIView?
    @IBOutlet weak var titleLbl: UILabel?
    @IBOutlet weak var messageLbl: UILabel?
    @IBOutlet weak var confirmBtn: UIButton?
    @IBOutlet weak var declineBtn: UIButton?
    
    var delegate: AgeConfirmationProtocol?
    var giveAway:Int?
    
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popView?.layer.cornerRadius = 10
    }

    @IBAction func confirm(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.ageConfirmation(tag: self.giveAway ?? 0)
        }
    }

    @IBAction func decline(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
