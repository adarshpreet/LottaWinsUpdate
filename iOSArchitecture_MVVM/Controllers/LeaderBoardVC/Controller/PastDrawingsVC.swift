//
//  PastDrawingsVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 24/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PastDrawingsVC: UIViewController {

    @IBOutlet weak var pastDrawingList: UITableView?
    
    @IBOutlet weak var buttonForGiveaway: CustomButton!
    @IBOutlet weak var buttonForLottery: CustomButton!
    var boolselected = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        boolselected = false
    }
    
    @IBAction func buttonForLotteryGiveaway(_ sender: CustomButton) {
        if sender.tag == 10 {boolselected = false
            buttonForLottery.setTitleColor(UIColor.white, for: .normal)
            buttonForLottery.backgroundColor = AppColor.DArkYellowColor
            buttonForGiveaway.setTitleColor(AppColor.DArkYellowColor, for: .normal)
            buttonForGiveaway.backgroundColor =  UIColor.white
            buttonForGiveaway.borderColor = AppColor.DArkYellowColor
            buttonForGiveaway.borderWidth = 3.0
        } else{
            boolselected = true
            buttonForGiveaway.setTitleColor(UIColor.white, for: .normal)
            buttonForGiveaway.backgroundColor = AppColor.DArkYellowColor
            buttonForLottery.setTitleColor(AppColor.DArkYellowColor, for: .normal)
            buttonForLottery.backgroundColor = UIColor.white
            buttonForLottery.borderColor = AppColor.DArkYellowColor
            buttonForLottery.borderWidth = 3.0

        }
        pastDrawingList?.reloadData()
    }
    @IBAction func acnCross(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension PastDrawingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if boolselected == false{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PastLotteryCell.className) as? PastLotteryCell else { return UITableViewCell() }
        cell.setup()
        return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PastGiveawayCell.className) as? PastGiveawayCell else { return UITableViewCell() }
//                   cell.setup()
                   return cell
        }
    }
}
