//
//  LeaderBoardVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

enum LeaderBoardEnum : Int {
    case thisWeek = 1
    case allTime
}

class LeaderBoardVC: BaseViewController {
    
    @IBOutlet weak var allWinnerList: UITableView?
    
    @IBOutlet weak var viewForback: UIView!
    @IBOutlet weak var lblType: UILabel?
    @IBOutlet weak var lblTypeBottom: UILabel?
    @IBOutlet weak var lblNo1: UILabel?
    @IBOutlet weak var lblNo2: UILabel?
    @IBOutlet weak var lblNo3: UILabel?
    @IBOutlet weak var lblNo4: UILabel?
    @IBOutlet weak var lblNo5: UILabel?
    @IBOutlet weak var lblDate: UILabel?
    @IBOutlet weak var lblAmount: UILabel?
    
    lazy var viewModel: LeaderBoardVM = {
        let obj = LeaderBoardVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.lblTypeBottom?.layer.cornerRadius = 3
//        self.lblTypeBottom?.clipsToBounds = true
//        lblAmount!.textColor = UIColor(patternImage: getGradientImage(lblAmount!.bounds))

    }
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()

           // Call the roundCorners() func right there.
           viewForback.roundCorners(corners: [.topLeft, .topRight], radius: 40)
       }
    
    // MARK:- IBActions
    @IBAction func acnShowPastDrawings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.home, bundle: nil)
        guard let popup = storyboard.instantiateViewController(withIdentifier: PastDrawingsVC.className) as? PastDrawingsVC else { return }
        popup.modalTransitionStyle = .crossDissolve
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: true, completion: nil)
    }
    func getGradientImage(_ bounds:CGRect) -> UIImage {

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 243, green: 58, blue: 168, alpha: 1.00).cgColor,
            UIColor(red: 56, green: 64, blue: 151, alpha: 1.00).cgColor
        ]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // changing start and end point value you can set vertical or horizontal
        gradientLayer.locations = [0.5,1]
        gradientLayer.bounds = bounds
        UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        gradientLayer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension LeaderBoardVC: BaseDataSources {
    
    func setUpClosures() {
        
    }
    
    func setUpView() {
        self.setUpClosures()
    }
}

extension LeaderBoardVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllWinnerTableCell") as? AllWinnerTableCell else { return UITableViewCell() }
        cell.setup()
        if indexPath.row == 0{
            cell.lblTier5!.isHidden = false
            cell.lblTier4!.isHidden = false
            cell.lblTier3!.isHidden = false
            cell.lblAmount!.text = "Jackpot"
        } else if indexPath.row == 1{
            cell.lblTier5!.isHidden = true
            cell.lblAmount!.text = "$250"

        }else if indexPath.row == 2{
            cell.lblTier5!.isHidden = true
            cell.lblTier4!.isHidden = true
            cell.lblAmount!.text = "$50"

        }
        else if indexPath.row == 3{
            cell.lblTier5!.isHidden = true
            cell.lblTier4!.isHidden = true
            cell.lblTier3!.isHidden = true
            cell.lblAmount!.text = "$10"

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Storyboards.home, bundle: nil)
        guard let popup = storyboard.instantiateViewController(withIdentifier: TierWinnerVC.className) as? TierWinnerVC else { return }
        popup.modalTransitionStyle = .crossDissolve
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: true, completion: nil)
    }
    
    
}
