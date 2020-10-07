//
//  LotteryHomeVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 21/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import MMPlayerView
import AVFoundation

class LotteryCell: UICollectionViewCell {
    @IBOutlet weak var corneredView: UIView?{
        didSet{
            self.corneredView?.layer.cornerRadius = (self.corneredView?.frame.height)!/2
            self.corneredView?.clipsToBounds = true
        }
    }
}

class LotteryHomeVC: BaseViewController {
    @IBOutlet weak var lotteryCollection: UICollectionView?
    @IBOutlet weak var giveAwayCollection: UICollectionView?
    var screenSize: CGRect?
    var giveawayDataModel: GiveAwayListBase?
    lazy var viewModel: LotteryHomeVM = {
        let obj = LotteryHomeVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    lazy var videoPlayer : MMPlayerLayer? = {
       let l = MMPlayerLayer()
       l.cacheType = .memory(count: 5)
       l.coverFitType = .fitToPlayerView
       l.videoGravity = AVLayerVideoGravity.resizeAspectFill
       l.repeatWhenEnd = true
       return l
    }()
    var offsetObservation: NSKeyValueObservation?

    // MARK:- View Life Cycle Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCollectionObserver()
        self.viewModel.fetchGiveAwayList()
        self.initVM()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //We are setting the layouts of collection View
        self.setLayouts()
        self.internalAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.internalDisAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.internalDisAppear()
    }
    
    // MARK:- Custom Tab Bar Methods
    func internalAppear() {
        self.updateVolumeByAvatar()
        self.playHorizontalCoverVideos()
    }
    
    func internalDisAppear() {
       self.stopPlayer()
    }
    
    func setLayouts() {
        screenSize = UIScreen.main.bounds
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenSize?.width ?? 375, height: (self.giveAwayCollection?.frame.size.height)!)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.giveAwayCollection?.collectionViewLayout = layout
    }
    
    func initVM() {
        
        viewModel.reloadListViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    layout.itemSize = CGSize(width: (self?.lotteryCollection?.frame.width)! / 4, height: 10)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0
                    self?.lotteryCollection?.collectionViewLayout = layout
                }
                self?.lotteryCollection?.reloadData()
                self?.giveAwayCollection?.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                   self?.playHorizontalCoverVideos()
                }
            }
        }
    }
}

extension LotteryHomeVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataCount = self.viewModel.listData.count
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == lotteryCollection {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LotteryCell.className, for: indexPath) as? LotteryCell
            let dataModel = self.viewModel.listData[indexPath.row]
                cell?.corneredView?.backgroundColor = dataModel.type == "Lottery" ? UIColor.init(red: 255.0/255.0, green: 180.0/255.0, blue: 4.0/255.0, alpha: 0.5) : .darkGray
            if indexPath.row == 0 {
               
                cell?.corneredView?.backgroundColor =  dataModel.type == "Lottery" ? AppColor.goldenColor : AppColor.whiteColor
               
            }
            return cell!
        } else if collectionView == giveAwayCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiveAwayCollectionCell.className, for: indexPath) as? GiveAwayCollectionCell
            let dataModel = self.viewModel.listData[indexPath.row]

//            cell?.backgroundImgView?.layer.cornerRadius = 25
//            cell?.backgroundImgView?.clipsToBounds = true
//            cell?.clipsToBounds = true
            cell!.delegate = self
            cell!.share?.tag = indexPath.row
            cell!.setupCell(dataModel)
            
            //Step 6: volumeOnOff
            let volume = Helper.shared.volumeSet
            self.videoPlayer?.player?.volume = volume
            
            guard let coverImage = dataModel.cover_image else { return cell! }

            if let mediaURL = coverImage.image {
                cell?.videoSoundButton.isHidden = mediaURL.isImage()
            }
            
            //Step 7: volumeOnOff
            cell!.videoSoundButton.addTarget(self, action: #selector(self.volumeOnOff(sender:)), for: .touchUpInside)
            cell!.videoSoundButton.tag = indexPath.row
            cell!.videoSoundButton.isSelected = volume > 0 ? true : false
            
            return cell!
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        for item in  0...self.viewModel.listData.count - 1 {
            let cell = lotteryCollection?.cellForItem(at: IndexPath(item: item, section: 0)) as? LotteryCell
            if item != index  {
            cell?.corneredView?.backgroundColor =  self.viewModel.listData[item].type == "Lottery"
                ? UIColor.init(red: 255.0/255.0, green: 180.0/255.0, blue: 4.0/255.0, alpha: 0.5) : .darkGray
            } else {
                cell?.corneredView?.backgroundColor =  self.viewModel.listData[item].type == "Lottery" ? AppColor.goldenColor : AppColor.whiteColor
            }
        }
    }
}

extension LotteryHomeVC: AgeConfirmationProtocol, GiveAwayCellDelegate {
    
    func tapOnSeeChat(tag: Int) {
        let model = self.viewModel.listData[tag]
        
        if let hasAccess = model.giveaway_access, hasAccess {
             self.stopPlayer()
            if let parent = self.parent as? TabBarVC {
                parent.showChatTab(detail: model, player: self.videoPlayer)
            }
        } else {
            
            self.viewModel.enterGiveAway(model: model) { (isTrue, errorMsg) in
                
                if isTrue {
                    self.viewModel.listData[tag].giveaway_access = true
                    self.tapOnSeeChat(tag: tag)
                } else {
                    let configAlert : AlertUI = ("", errorMsg)
                    UIAlertController.showAlert(configAlert)
                }
            }
        }
    }
    
    func callBackFromChatVc() {
        DispatchQueue.main.async {
            if let centerCellIndexPath = self.giveAwayCollection!.centerCellIndexPath {
                self.enterGiveAway(tag: centerCellIndexPath.item)
            }
        }
    }
    
    func enterGiveAway(tag: Int) {
        
        let dataModel = self.viewModel.listData[tag]
        guard dataModel.isAge_confirmation_box ?? false else {
            self.ageConfirmation(tag: tag)
            return
        }
        let popup = AgeConfirmationPopup()
        popup.delegate = self
        popup.giveAway = tag
        popup.modalTransitionStyle = .crossDissolve
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: true, completion: nil)
    }

    func shareGiveAway(tag: Int) {
        
        let dataModel = self.viewModel.listData[tag]
        guard let imageURL = URL(string:dataModel.cover_image?.image ?? "") else { return }
        let items = ["Play live lottery and win cash, exclusive prizes", imageURL] as [Any]
        DispatchQueue.main.async {
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
        }
    }
    
    func ageConfirmation(tag: Int) {
        
        let model = self.viewModel.listData[tag]
        
        if let hasAccess = model.giveaway_access, hasAccess {
            let storyboard = UIStoryboard(name: "Coins", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: MyCoinsVC.className) as? MyCoinsVC else { return }
            controller.viewModel.singleGiveAway = model
            self.navigationController?.show(controller, sender: self)
        } else {
            
            self.viewModel.enterGiveAway(model: model) { (isTrue, errorMsg) in
                
                if isTrue {
                    self.viewModel.listData[tag].giveaway_access = true
                    self.ageConfirmation(tag: tag)
                } else {
                    let configAlert : AlertUI = ("", errorMsg)
                    UIAlertController.showAlert(configAlert)
                }
            }
        }
    }
}
