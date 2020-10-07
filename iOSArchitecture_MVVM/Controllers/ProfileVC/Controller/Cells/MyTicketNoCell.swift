//
//  MyTicketNoCell.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 11/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class MyTicketNoCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ticketNoTable: UITableView?
    
    var dataSource: AllGeneratedTickets?
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 304
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "MyTicketHeaderCell") as? MyTicketHeaderCell else { return UIView() }
        headerCell.setupCell(self.dataSource!)
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.code?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketsNumberCell.className) as? MyTicketsNumberCell else { return UITableViewCell() }
        cell.setupCell(self.dataSource?.code?[indexPath.row] ?? [Int](), self.dataSource?.start_date ?? "")
//        if indexPath.row == (self.dataSource?.code?.count ?? 0) - 1  {
//            cell.bgImgView?.image = UIImage(named: "zigZagDown")
//        } else {
//            cell.bgImgView?.image = UIImage(named: "ticketCellBG")
//        }
        return cell
    }
    
    
    func reloadList() {
        self.ticketNoTable?.reloadData()
    }
    
    
    
}
