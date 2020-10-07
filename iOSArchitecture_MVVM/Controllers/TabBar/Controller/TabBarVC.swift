//
//  TabBarVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/27/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import MMPlayerView

class TabBarVC: BaseViewController {
    
    @IBOutlet weak var giveAwayVC: UIView!
    @IBOutlet weak var leaderBoardVC: UIView!
    @IBOutlet weak var profileVC: UIView!
    @IBOutlet weak var lotteryChatVC: UIView!

    @IBOutlet weak var viewForProfile: EditingView!
    @IBOutlet weak var viewForLeadboard: EditingView!
    @IBOutlet weak var viewForChat: EditingView!
    @IBOutlet var tabList: [UIButton]!
    var giveAwayDetail : GiveAwayListBase?

    override func viewDidLoad() {
        super.viewDidLoad()
        // This is for the first time when user comes to the home page
        AppUser.defaults.set(true, forKey: DefaultKeys.openFirstTime)
        self.activateCurrentTab(0)
        viewForLeadboard.isHidden = true
        viewForProfile.isHidden = true

    }
    
    @IBAction func tabBarClick(_ sender: UIButton) {
        self.activateCurrentTab(sender.tag)
    }
    
    func activateCurrentTab(_ index: Int) {
        
        switch index {
        case 0:
            self.tabList[0].isSelected = true
            self.giveAwayVC.isHidden = false
            self.leaderBoardVC.isHidden = true
            self.profileVC.isHidden = true
            viewForLeadboard.isHidden = true
            viewForProfile.isHidden = true
            viewForChat.isHidden = false

            for controller in self.children {
                if let chatVC = controller as? LotteryHomeVC {
                    chatVC.internalAppear()
                    break
                }
            }
        case 1:
            self.giveAwayVC.isHidden = true
            self.leaderBoardVC.isHidden = false
            self.profileVC.isHidden = true
            viewForLeadboard.isHidden = false
            viewForProfile.isHidden = true
            viewForChat.isHidden = true

            for controller in self.children {
                if let chatVC = controller as? LotteryHomeVC {
                    chatVC.internalDisAppear()
                }
            }
        default:
            self.giveAwayVC.isHidden = true
            self.leaderBoardVC.isHidden = true
            self.profileVC.isHidden = false
            viewForLeadboard.isHidden = true
            viewForProfile.isHidden = false
            viewForChat.isHidden = true
            for controller in self.children {
                if let chatVC = controller as? LotteryHomeVC {
                    chatVC.internalDisAppear()
                } else if let chatVC = controller as? ProfileVC {
                    chatVC.profileInternalDidLoad()
                }
            }
        }
        self.activeCurrentImage(index)
    }
    
    func activeCurrentImage(_ index: Int) {
        
        for tab in self.tabList {
            tab.isSelected = tab.tag == index
        }
    }
    
    func showChatTab(detail: GiveAwayListBase, player: MMPlayerLayer?) {
        self.giveAwayVC.isHidden = true
        self.lotteryChatVC.isHidden = false
        for controller in self.children {
            if let chatVC = controller as? LotteryChatVC {
                chatVC.viewModel.giveAwayDetail = detail
                chatVC.videoPlayer = player
                break
            }
        }
    }
    
    func showGiveAwayTab(_ isClickEnterGiveAway:Bool = false) {
        self.giveAwayVC.isHidden = false
        self.lotteryChatVC.isHidden = true
        for controller in self.children {
            if let chatVC = controller as? LotteryHomeVC {
                chatVC.internalAppear()
                if isClickEnterGiveAway {
                    chatVC.callBackFromChatVc()
                }
                break
            }
        }
    }

}


