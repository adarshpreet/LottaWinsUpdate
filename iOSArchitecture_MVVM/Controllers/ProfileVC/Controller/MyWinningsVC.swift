//
//  MyWinningsVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Gurpreet Singh on 05/10/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class MyWinningsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
            }
            
        }


        extension MyWinningsVC: UITableViewDataSource, UITableViewDelegate {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return 5
            }
            
            func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 70
            }
            
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TierWinnerTableCell.className) as? TierWinnerTableCell else { return UITableViewCell() }
                cell.setup()
                return cell
            }
        }


