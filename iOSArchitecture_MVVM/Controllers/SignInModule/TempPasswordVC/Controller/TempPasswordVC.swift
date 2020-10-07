//
//  TempPasswordVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class TempPasswordVC: BaseViewController {
    
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    lazy var viewModel: TempPasswordVM = {
       let obj = TempPasswordVM(userService: UserService())
       self.baseVwModel = obj
       return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    // MARK:- Actions
    @IBAction func tapOnContinue(_ sender: Any) {
        self.viewModel.validations(self.passwordTF.text)
    }
    
    @IBAction func tapOnResend(_ sender: Any) {
        self.viewModel.generateTempPasswordService()
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}

extension TempPasswordVC : BaseDataSources {
    
    func setUpView() {
        self.setUpClosures()
    }
    
    func setUpClosures() {
        self.viewModel.redirectControllerClosure = { [weak self] in
           guard let self = `self` else { return }
           DispatchQueue.main.async {
               self.performSegue(withIdentifier: Segues.generateNewPassword, sender: self)
           }
        }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
           guard let self = `self` else { return }
           let message = serverMessage ?? ""
           DispatchQueue.main.async {
               self.erroViewDisplay(false, message: message)
           }
        }
        
        self.viewModel.updateUI = { [weak self] errortype in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
//                switch errortype {
//                case .password:
//                     self.passwordTF.borderColor = AppColor.orangeColor
//                     self.passwordTF.borderWidth = 2
//                     
//                     self.passwordTF.placeholderColor = AppColor.orangeColor
//                     let count = (self.passwordTF.text ?? "").count
//
//                     self.erroViewDisplay(false, message:count == 0 ? AlertMessage.emptyPassword : AlertMessage.limitPassword)
//                     self.passwordTF.becomeFirstResponder()
//                    break
//                  default:break
//                }
            }
        }
    }
    
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        self.errorView.isHidden = false
           self.errorLabel.text = message
           // change to desired number of seconds (in this case 5 seconds)
           let when = DispatchTime.now() + 3
           DispatchQueue.main.asyncAfter(deadline: when) {
             // your code with delay
               UIView.animate(withDuration: 0.5) {
                   self.errorView.isHidden = true
               }
           }
       }
}
