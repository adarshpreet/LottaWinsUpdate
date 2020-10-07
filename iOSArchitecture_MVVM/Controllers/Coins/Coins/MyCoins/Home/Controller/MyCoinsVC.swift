//
//  MyCoinsVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 19/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import AVKit

class NumberCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLbl: UILabel?{
        didSet{
            self.numberLbl?.layer.cornerRadius = 23
            self.numberLbl?.backgroundColor = UIColor("EFEBF6")
            self.numberLbl?.clipsToBounds = true
        }
    }
}

class MyCoinsVC: BaseViewController, BaseDataSources {
    @IBOutlet weak var imageLock: UIImageView!
    @IBOutlet weak var scrlView: UIScrollView?
    @IBOutlet weak var internalView: UIView?
    @IBOutlet weak var stackView: UIStackView?
    @IBOutlet weak var numberView: UIView?
    @IBOutlet weak var numberCollection: UICollectionView?
    @IBOutlet weak var pageControl: UIPageControl?
    @IBOutlet weak var coinView: UIView?
    @IBOutlet weak var brandedContentButton: CustomButton?
    @IBOutlet weak var videoAdButton: CustomButton?
    @IBOutlet weak var quizButton: CustomButton?
    @IBOutlet weak var myCoinsLabel: UILabel?
    @IBOutlet var tabList: [CustomButton]!
    @IBOutlet var questionLabelList: [CustomLabel]!
    @IBOutlet var DiceImgView: UIImageView?
    @IBOutlet weak var heightConstraints: NSLayoutConstraint?
    
    @IBOutlet weak var buttonFOrCoin: CustomButton!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2Tick: UIImageView!
    @IBOutlet weak var imageViewForTick: UIImageView!
    @IBOutlet weak var viewForChooseNumbers: UIView!
    @IBOutlet weak var viewForReferralCode: UIView!
    @IBOutlet weak var viewForEarnCoins: UIView!
    @IBOutlet weak var viewForMyCoins: UIView!
    var selectedField: UITextField?
    var arrData = [String]() // This is  data array
    var arrSelectedIndex = [Int]() // This is selected cell Index array
    var arrSelectedData = [Int]()
    var itemCount = 0
    var giveawayData: GiveAwayListBase?
    var diceImgArray: [UIImage] = [UIImage]()
    
    @IBOutlet weak var buttonButtonConstraint: NSLayoutConstraint!
    
    lazy var viewModel: MyCoinsVM = {
        let obj = MyCoinsVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    // MARK:- View Life Cycle Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize Google Ads
        GoogleAds.shared.initialize()
        self.setUpView()
        diceImgArray.append(UIImage(named: "Dice1") ?? UIImage())
        diceImgArray.append(UIImage(named: "Dice2") ?? UIImage())
        diceImgArray.append(UIImage(named: "Dice3") ?? UIImage())
        diceImgArray.append(UIImage(named: "Dice4") ?? UIImage())
        diceImgArray.append(UIImage(named: "Dice5") ?? UIImage())
        diceImgArray.append(UIImage(named: "Dice6") ?? UIImage())
        self.imageViewForTick.isHidden =  true
        self.imageView1.isHidden = true
        self.imageView2Tick.isHidden = true
        imageLock.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setUpView()
        self.viewModel.fetchGiveAwayDetail()
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if #available(iOS 11.0, *) {
//                   numberView!.clipsToBounds = true
//                   numberView!.layer.cornerRadius = 50
//                   numberView!.layer.maskedCorners = [.layerMaxXMaxYCorner]
//               } else {
//                  // Fallback on earlier versions
//               }
//    }
    func setUpClosures() {
        
        self.viewModel.redirectClosure = { [weak self] type in
            guard let self = `self` else { return }
            
            if type == "giveAwayDetail" {
                self.enableContentActions()
            } else if type == "sponsoredContent" {
                if let list = self.viewModel.sponsoredList, list.count > 0 {
                    self.showBrandedContent(list)
                }
            } else if type == "quizList" {
                
                if let list = self.viewModel.quizList, list.count > 0 {

                    let storyboard = UIStoryboard(name: Storyboards.home, bundle: nil)
                    guard let quizVC = storyboard.instantiateViewController(withIdentifier: PersonalityQuizVC.className) as? PersonalityQuizVC else { return }
                    quizVC.viewModel.quizModel = list
                    quizVC.viewModel.singleGiveAway = self.viewModel.singleGiveAway
                    quizVC.onMessage = { [weak self] snapShot in
                        guard let self = `self` else { return }
                        
                        if let giveAwayDetail = snapShot as? GiveAwayDetail {
                            self.viewModel.giveAwayDetail = giveAwayDetail
                        }
                    }
                    self.navigationController?.show(quizVC, sender: self)
                }
            } else if type == "showTicketDetail" {
                self.setUpView()
                
                let storyboard = UIStoryboard(name: Storyboards.home, bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: EnteredGiveawayVC.className) as? EnteredGiveawayVC else { return }
                controller.dataModel = self.viewModel.createTicketResponse
                controller.giveAwayDetail = self.viewModel.giveAwayDetail
                controller.singleGiveAway = self.viewModel.singleGiveAway
                self.navigationController?.pushViewController(controller, animated: false)
            } else if type == "createTicket" {
                //
                let configAlert : AlertUI = ("", AlertMessage.createTicket)

                UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.Okk) { [weak self] (isItem) in
                    guard let self = `self` else { return }
                   if isItem.title == AlertAction.Okk.title {
                        self.navigationController?.popViewController(animated: true)
                   }
                }
            }
        }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
            guard let _ = `self` else { return }
            let message = serverMessage ?? ""
            DispatchQueue.main.async {
                let configAlert : AlertUI = ("", message)
                UIAlertController.showAlert(configAlert)
            }
        }
    }
    
    func enableContentActions() {
        guard let model = self.viewModel.giveAwayDetail else { return }
        self.myCoinsLabel?.text = "\(model.coins ?? 0)"
        let isSponsoredContent = model.has_sponsored_content ?? false
        let isSurvey = model.has_survey ?? false
       

        self.brandedContentButton?.backgroundColor = isSponsoredContent ? AppColor.whiteColor : AppColor.ClickBlueColor
        self.quizButton?.backgroundColor = isSurvey ? AppColor.whiteColor : AppColor.ClickBlueColor
        self.brandedContentButton?.isEnabled = isSponsoredContent
        self.quizButton?.isEnabled = isSurvey

//        self.tabList[0].backgroundColor = isSponsoredContent ? AppColor.grayColor : AppColor.orangeColor
//        self.tabList[1].backgroundColor = isSurvey ? AppColor.grayColor : AppColor.orangeColor
        self.imageViewForTick.isHidden = isSponsoredContent ? true : false
        self.imageView1.isHidden = isSurvey ? true : false
         if self.isMobAds {
             imageLock.isHidden = true
        }
         else{
            self.videoAdButton?.backgroundColor =  UIColor.init("#D7D7D7")
             imageLock.isHidden = false
        }

//        self.questionLabelList[0].backgroundColor = isSponsoredContent ? AppColor.grayColor : AppColor.orangeColor
//        self.questionLabelList[1].backgroundColor = isSurvey ? AppColor.grayColor : AppColor.orangeColor

    }
    
    func setUpView() {
        
        //Configuring Datasource
        self.arrSelectedData = [0,0,0,0,0]
        self.arrSelectedIndex = [-1, -1, -1, -1, -1]
        let arrangedView = self.stackView?.arrangedSubviews
        for item in arrangedView! {
            if let field = item as? UITextField {
                field.text = ""
            }
        }
        self.numberCollection?.reloadData()
        self.scrlView?.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: 920)
        self.numberLayout()
        self.setUpClosures()
        
        self.numberView?.clipsToBounds = true
        self.numberView?.layer.cornerRadius = 20
        self.numberView?.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }

    func numberLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (numberCollection?.frame.size.width ?? 360)/6, height: (numberCollection?.frame.size.height ?? 360) / 5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.numberCollection?.collectionViewLayout = layout
        self.numberView?.isHidden = true
        self.scrlView?.isScrollEnabled = true
    }

    // MARK: - Custom Actions
    @IBAction func acnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var isMobAds: Bool {
        
        guard let model = self.viewModel.giveAwayDetail else { return false }
        let isSponsoredContent = model.has_sponsored_content ?? false
        let isSurvey = model.has_survey ?? false
        return !isSponsoredContent && !isSurvey ? true : false
    }
    
    func showBrandedContent(_ list: [SponsoredContent]) {
          let storyboard = UIStoryboard(name: Storyboards.home, bundle: nil)
          guard let brandedContentVC = storyboard.instantiateViewController(withIdentifier: BrandedContentVC.className) as? BrandedContentVC else { return }
          brandedContentVC.model = list[self.viewModel.currentSponsorIndex]
          brandedContentVC.onMessage = { [weak self] snapShot in
              guard let self = `self` else { return }
              if let isComplete = snapShot as? Bool, isComplete {
                self.viewModel.increaseSponsoredCoins(content:list[self.viewModel.currentSponsorIndex])
              }
          }
          self.present(brandedContentVC, animated: true, completion: nil)
    }
    
    @IBAction func acnWatchBrandedContent(_ sender: UIButton) {
        
        if let list = self.viewModel.sponsoredList, list.count > 0 {
            //check brandedContents available for the current index or not
            guard self.viewModel.currentSponsorIndex < list.count else { return }
            self.showBrandedContent(list)
        } else {
            // else condition would execute when user click for the first time and we have to fetch all the branded contents lists.
            self.viewModel.fetchSponsoredContent()
        }
    }
    
    @IBAction func acnWatchVideoAd(_ sender: UIButton) {
        
        if self.isMobAds { // User is able to see the Mob Ads only and only if he completes both the options of sponsored content and quiz.
            if GoogleAds.shared.interstitial.isReady {
                GoogleAds.shared.interstitial.present(fromRootViewController: self)
                GoogleAds.shared.finish = { [weak self] in
                    guard let self = `self` else { return }
                    // This method will call when mob ads finish
                    self.viewModel.increaseAdMobCoins()
                }
            } else {
                let configAlert: AlertUI = ("", "Please wait while ads are loading.")
                UIAlertController.showAlert(configAlert)
            }
        } else {
            let configAlert: AlertUI = ("", "Please watch sponsored content and Quiz section.")
            UIAlertController.showAlert(configAlert)
        }
    }
    
    @IBAction func acnTakePersonalityQuiz(_ sender: UIButton) {
        self.viewModel.fetchQuizLists()
    }
    
    @IBAction func acnShowReferralPopup(_ sender: UIButton) {
        let popup = PopController()
        popup.viewModel.giveAwayDetail = self.viewModel.giveAwayDetail
        popup.onMessage = { [weak self] snapShot in
            guard let self = `self` else { return }
            
            if let giveAwayDetail = snapShot as? GiveAwayDetail {
                self.viewModel.giveAwayDetail = giveAwayDetail
            }
        }
        popup.modalTransitionStyle = .crossDissolve
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func hideNumberPicker(_ sender: UIButton) {
        self.heightConstraints?.constant = 920
        self.numberView?.isHidden = true
        self.scrlView?.isScrollEnabled = true
    }
    
    //---------------------------------------------//
    //----------- DICE ROLL CHANGES ---------------//
    
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32) -> [Int] {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < numberOfRandoms {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
        }
        return uniqueNumbers.shuffled()
    }
    
    func uniqueRandoms(numberOfRandoms: Int, minNum: Int, maxNum: UInt32, blackList: Int?) -> [Int] {
        var uniqueNumbers = Set<Int>()
        while uniqueNumbers.count < numberOfRandoms {
            uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
        }
        if let blackList = blackList {
            if uniqueNumbers.contains(blackList) {
                while uniqueNumbers.count < numberOfRandoms+1 {
                    uniqueNumbers.insert(Int(arc4random_uniform(maxNum + 1)) + minNum)
                }
                uniqueNumbers.remove(blackList)
            }
        }
        return uniqueNumbers.shuffled()
    }
    
    //---------- DICE ROLL CHANGES ENDS -----------//
    //---------------------------------------------//
    
    
    @IBAction func acnDiceRoll(_ sender: UIButton) {
         let randNumbers = uniqueRandoms(numberOfRandoms: 5, minNum: 0, maxNum: 60, blackList: 0)
               let arrangedTxtFld = self.stackView?.arrangedSubviews
               for (index, element) in randNumbers.enumerated() {
                 print("Item \(index): \(element)")
                   if arrSelectedIndex[index] == -1 {
                       let indexRow = element - 1
                       if arrSelectedIndex.contains(indexRow) {
                           let itemIndex = arrSelectedIndex.firstIndex(of: indexRow)
                           arrSelectedIndex[itemIndex!] = -1 // .remove(at: itemIndex!)
                           if let txtFld = arrangedTxtFld?[itemIndex!].subviews[0] as? UITextField {
                               txtFld.text = ""
                           }
                           arrSelectedData[itemIndex!] = 0
                           itemCount = itemCount - 1
                       }
                       else {
                           arrSelectedIndex[index] = indexRow
                           arrSelectedData[index] = indexRow + 1
                       }
                   }
               }
           self.numberCollection?.reloadData()
               for item in arrSelectedData {
                   if item != 0 {
                       let itemIndex = arrSelectedData.firstIndex(of: item)
                       if let txtFld = arrangedTxtFld?[itemIndex!].subviews[0] as? UITextField {
                           txtFld.text = "\(item)"
                       }
                   }
               }
               let zeroValArr = arrSelectedData.filter({$0 == 0})
               if zeroValArr.count == 0 {
                   self.heightConstraints?.constant = 920
                   self.numberView?.isHidden = true
                self.scrlView?.isScrollEnabled = true

               }
    }
    
    @IBAction func deleteLotteryNumber() {
        let arrangedTxtFld = self.stackView?.arrangedSubviews
        for item in arrSelectedIndex.reversed() {
            if item != -1 {
                let index = arrSelectedIndex.firstIndex(of: item)
                arrSelectedIndex[index!] = -1
                arrSelectedData[index!] = 0
                if let txtFld = arrangedTxtFld?[index!].subviews[0] as? UITextField {
                    txtFld.text = ""
                }
                self.numberCollection?.reloadData()
                break
            }
        }
    }

    @IBAction func acnRollTheDice(_ sender: UIButton) {
          self.DiceImgView?.animationImages = self.diceImgArray
              self.DiceImgView?.animationDuration = 1.0
              self.DiceImgView?.startAnimating()
          
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                  self.DiceImgView?.stopAnimating()
                  let randNumbers = self.uniqueRandoms(numberOfRandoms: 5, minNum: 0, maxNum: 60, blackList: 0)
                  let arrangedTxtFld = self.stackView?.arrangedSubviews
                  for (index, element) in randNumbers.enumerated() {
                      if self.arrSelectedIndex[index] == -1 {
                      let indexRow = element - 1
                          if self.arrSelectedIndex.contains(indexRow) {
                              let itemIndex = self.arrSelectedIndex.firstIndex(of: indexRow)
                              self.arrSelectedIndex[itemIndex!] = -1 // .remove(at: itemIndex!)
                              if let txtFld = arrangedTxtFld?[itemIndex!].subviews[0] as? UITextField {
                                  txtFld.text = ""
                                txtFld.layer.borderColor = AppColor.newBlueColor.cgColor
                                txtFld.layer.borderWidth = 3.0
                              }
                              self.arrSelectedData[itemIndex!] = 0
                              self.itemCount = self.itemCount - 1
                          }
                          else {
                              self.arrSelectedIndex[index] = indexRow
                              self.arrSelectedData[index] = indexRow + 1
                          }
                      }
                  }
                  self.numberCollection?.reloadData()
                  for item in self.arrSelectedData {
                          if item != 0 {
                              let itemIndex = self.arrSelectedData.firstIndex(of: item)
                              if let txtFld = arrangedTxtFld?[itemIndex!].subviews[0] as? UITextField {
                                txtFld.layer.borderColor = AppColor.pinkColor.cgColor
                                txtFld.layer.borderWidth = 3.0
                    
                                  txtFld.text = "\(item)"
                              }
                          }
                      }
                  let zeroValArr = self.arrSelectedData.filter({$0 == 0})
                  if zeroValArr.count == 0 {
                      self.heightConstraints?.constant = 920
                      self.numberView?.isHidden = true
                    self.scrlView?.isScrollEnabled = true

//                    self.buttonFOrCoin.backgroundColor = AppColor.pinkColor
//                    self.buttonFOrCoin.setTitleColor(UIColor.white, for: .normal)
                  }
              }
    }
    
    @IBAction func useCoin(_ sender: UIButton) {
        let zeroValArr = arrSelectedData.filter({$0 == 0})
        if zeroValArr.count == 0 {
            self.viewModel.createTicket(self.arrSelectedData)
        }
        }
        
    @IBAction func buttonForTap(_ sender: UIButton) {
         self.heightConstraints?.constant = 1200
         self.numberView?.isHidden = false
        
         let bottomOffset = CGPoint(x: 0, y: 400)
         self.scrlView?.setContentOffset(bottomOffset, animated: true)
        self.scrlView?.isScrollEnabled = false
    }
}


extension MyCoinsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumberCollectionCell.className, for: indexPath) as? NumberCollectionCell else {
            return UICollectionViewCell()
        }
        cell.numberLbl?.text = "\(indexPath.item + 1)"
        if arrSelectedIndex.contains(indexPath.row) { // You need to check wether selected index array contain current index if yes then change the color
            cell.numberLbl?.backgroundColor = UIColor("E3226D")
            cell.numberLbl?.textColor = .white
        } else {
            cell.numberLbl?.backgroundColor = UIColor("EFEBF6")
            cell.numberLbl?.textColor = AppColor.newPlaceholderColor
        }
        cell.layer.cornerRadius = 10
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arrangedTxtFld = self.stackView?.arrangedSubviews
        if arrSelectedIndex.contains(indexPath.row) {
            let itemIndex = arrSelectedIndex.firstIndex(of: indexPath.row)
            arrSelectedIndex[itemIndex!] = -1 // .remove(at: itemIndex!)
            if let txtFld = arrangedTxtFld?[itemIndex!].subviews[0] as? UITextField {
                txtFld.text = ""
                txtFld.layer.borderColor = AppColor.newBlueColor.cgColor
                txtFld.layer.borderWidth = 3.0
            }
            arrSelectedData[itemIndex!] = 0
            itemCount = itemCount - 1
        } else {
            for item in arrSelectedIndex {
                if item == -1 {
                    let itemIndex = arrSelectedIndex.firstIndex(of: item)
                    arrSelectedIndex[itemIndex!] = indexPath.row
                    arrSelectedData[itemIndex!] = indexPath.row + 1
                    break
                }
            }
        }
        collectionView.reloadData()
        
        for item in arrSelectedData {
            if item != 0 {
                let itemIndex = arrSelectedData.firstIndex(of: item)
                if let txtFld = arrangedTxtFld?[itemIndex!].subviews[0] as? UITextField {
                    txtFld.text = "\(item)"
                    txtFld.layer.borderColor = AppColor.pinkColor.cgColor
                    txtFld.layer.borderWidth = 3.0
                }
            }
        }
        
        let zeroValArr = arrSelectedData.filter({$0 == 0})
        if zeroValArr.count == 0 {
            self.heightConstraints?.constant = 920
            self.numberView?.isHidden = true
            self.scrlView?.isScrollEnabled = true

            self.buttonFOrCoin.backgroundColor = AppColor.pinkColor
            self.buttonFOrCoin.setTitleColor(UIColor.white, for: .normal)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

extension MyCoinsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(false)
        self.heightConstraints?.constant = 1200
//       self.bottomContraint.constant = 70
        self.numberView?.isHidden = false
        self.selectedField = textField
        let bottomOffset = CGPoint(x: 0, y: 300)
        self.scrlView?.setContentOffset(bottomOffset, animated: true)
        return true
    }
}

