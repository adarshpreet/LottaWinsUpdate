//
//  WelcomeVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 05/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class WelcomeVC: BaseViewController {
    
    @IBOutlet weak var firstBtn: CustomButton!
    @IBOutlet weak var secondBtn: CustomButton!
    @IBOutlet weak var viewForButtons: UIView!
    @IBOutlet weak var labelForNewLottery: UILabel!
    // MARK:- View Life Cycle Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstBtn.setTitle(self.isAppOpen ? "LOGIN" : "GET STARTED", for: .normal)
        self.secondBtn.setTitle(self.isAppOpen ? "GET STARTED" : "LOGIN", for: .normal)
        self.labelForNewLottery.textColor = self.isAppOpen ? AppColor.pinkColor : AppColor.newBlueColor
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Call the roundCorners() func right there.
        viewForButtons.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    var isAppOpen: Bool {
        return AppUser.defaults.bool(forKey: DefaultKeys.openFirstTime)
    }
    
    // MARK:- IB Actions Start
    @IBAction func btnGetStartedAction(_ sender: Any) {
        self.loginAction(self.isAppOpen)
    }
            
    @IBAction func btnLoginAction(_ sender: Any) {
        self.loginAction(!self.isAppOpen)
    }
    
    func loginAction(_ isForLogin: Bool) {
        let vc = self.mainStoryboardController(withIdentifier: PhoneSignupVC.className) as! PhoneSignupVC
//        let navigation = UINavigationController(rootViewController: vc)
//        navigation.modalPresentationStyle = .overCurrentContext
//        navigation.modalTransitionStyle = .crossDissolve
         vc.isForLogin = isForLogin
        self.navigationController?.show(vc, sender: self)
        
//        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: SocialSignUpVC.className) as! SocialSignUpVC
//        signUpVC.isForLogin = isForLogin //false for signup
//        let navigation = UINavigationController(rootViewController: signUpVC)
//        navigation.modalPresentationStyle = .overCurrentContext
//        navigation.modalTransitionStyle = .crossDissolve
//        self.present(navigation, animated: true, completion: nil)
    }
}
