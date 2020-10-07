//
//  PopController.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 19/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PopController: BaseViewController {

    @IBOutlet weak var alertView: UIView?
    @IBOutlet weak var popupTitleLbl: UILabel?
    @IBOutlet weak var txtField: CustomTextField?
    @IBOutlet weak var alertLbl: UILabel?
    @IBOutlet weak var crossBtn: UIButton?

    var onMessage: SwiftCallBacks.handler?

    lazy var viewModel: PopControllerVM = {
        let obj = PopControllerVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    @IBAction func tapOnCross(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func dismissAlert(_ sender: UIButton) {
        self.viewModel.validate(self.txtField?.text)
    }
}

extension PopController : BaseDataSources {
    
    func setUpClosures() {
        self.viewModel.updateUI = { [weak self] errortype in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                self.alertLbl?.text = AlertMessage.invalidReferralCode
                self.txtField?.hightLighttextField()
            }
        }
        
        self.viewModel.redirectClosure = { [weak self] type in
            guard let self = `self` else { return }
            guard let giveAway = self.viewModel.giveAwayDetail else { return }
            self.onMessage?(giveAway)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
           guard let self = `self` else { return }
           let message = serverMessage ?? ""
           DispatchQueue.main.async {
               self.alertLbl?.text = message
               self.txtField?.hightLighttextField()
           }
       }
    }
    
    func setUpView() {
        self.alertView?.layer.cornerRadius = 10
        self.alertView?.clipsToBounds = true
        self.alertLbl?.text = ""
        self.setUpClosures()
        
        let origImage = #imageLiteral(resourceName: "ic_close")
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        self.crossBtn?.setImage(tintedImage, for: .normal)
        self.crossBtn?.tintColor = .black
    }

}
