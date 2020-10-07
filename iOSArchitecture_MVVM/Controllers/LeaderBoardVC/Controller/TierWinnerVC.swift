//
//  TierWinnerVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 19/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class TierWinnerVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func acnCross(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}


extension TierWinnerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TierWinnerTableCell.className) as? TierWinnerTableCell else { return UITableViewCell() }
        cell.setup()
        return cell
    }    
}
