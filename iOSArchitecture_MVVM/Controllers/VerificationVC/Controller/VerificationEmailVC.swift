//
//  VerificationEmailVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/13/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class VerificationEmailVC: BaseViewController {
    
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var verifyLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!

    lazy var viewModel: VerificationEmailVM = {
        let obj = VerificationEmailVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    //MARK:- View Life Cycle Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    //MARK:- IBActions
    @IBAction func tapOnContinue(_ sender: Any) {
        self.segueToNextVC()
    }
    
    private func segueToNextVC() {
        self.viewModel.isMoved = true
        if self.viewModel.bitmojiURL.count > 0 {
            self.performSegue(withIdentifier: Segues.uploadBitMojiSegue, sender: self)
        } else {
            self.performSegue(withIdentifier: Segues.photoSegue, sender: self)
        }
    }
    
    @IBAction func tapOnResendEmail(_ sender: Any) {
        self.viewModel.resendVerificationLink()
    }
    
    func initializeWebSocket() {
        SwiftSockets.shared.initilaize(urlString: Config.socketURL)
        SwiftSockets.shared.onMessage = { [weak self] response in
            guard let self = `self` else { return }
            if let dict = response as? KeyValue {
                if let emailConfirmed = dict[Keys.messageSocketKey] as? String, emailConfirmed == SocketEnum.emailVerified.rawValue {
                    self.enableContinueButton()
                }
            }
        }
    }
    
    func enableContinueButton() {
        
        DispatchQueue.main.async {
            guard self.continueButton.isEnabled == false else { return }
            self.enableButton(true)
            self.verifyLabel.text = "Your email has been verified successfully."
            self.resendButton.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                // User would be redirected after 3 seconds if user doesn't click on the continue button
                guard self.viewModel.isMoved == false else { return }
                self.segueToNextVC()
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Segues.uploadBitMojiSegue {
            guard let destination = segue.destination as? AddPhotoBitmojiVC else { return }
            destination.bitmojiURL = self.viewModel.bitmojiURL
        }
    }
    
}

extension VerificationEmailVC: BaseDataSources {
    
    func setUpView() {
        self.setUpClosures()
        self.enableButton(false)
        self.initializeWebSocket()
    }
    
    func enableButton(_ isEnable: Bool) {
        self.continueButton.isEnabled = isEnable
        self.continueButton.backgroundColor = isEnable ? AppColor.greenColor : UIColor.lightGray
    }
    
    func setUpClosures() {
        self.viewModel.redirectControllerClosure = { [weak self] in
             guard let self = `self` else { return }
             DispatchQueue.main.async {
                 self.performSegue(withIdentifier: Segues.photoSegue, sender: self)
             }
         }
         
         self.viewModel.serverErrorMessages = { [weak self] serverMessage in
            guard let self = `self` else { return }
            let message = serverMessage ?? ""
            DispatchQueue.main.async {
               self.erroViewDisplay(false, message: message)
            }
         }
    }
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        self.errorView.isHidden = isShow
        self.errorLabel.text = message
    }
    
}
