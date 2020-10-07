//
//  NewPasswordVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class NewPasswordVC: BaseViewController {
    
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var confirmPasswordTF: CustomTextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    lazy var viewModel: NewPasswordVM = {
        let obj = NewPasswordVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    
    // MARK:- Actions
   @IBAction func tapOnContinue(_ sender: Any) {
        self.viewModel.validations(self.passwordTF.text, confirmPassword: self.confirmPasswordTF.text)
   }
    
    @IBAction func tapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewPasswordVC : BaseDataSources {
    
    func setUpView() {
        self.setUpClosures()
    }
    
    func setUpClosures() {
        self.viewModel.redirectControllerClosure = { [weak self] in
           guard let self = `self` else { return }
           DispatchQueue.main.async {
               let configAlert: AlertUI = ("", AlertMessage.accountPasswordReset)
               UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.Okk) { (handler) in
                    self.navigationController?.popToViewController(ofClass: LoginUsernameVC.self)
               }
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
//               switch errortype {
//               case .password:
//                   self.passwordTF.borderColor = AppColor.orangeColor
//                   self.passwordTF.borderWidth = 2
//                   self.confirmPasswordTF.borderColor = UIColor.clear
//                   self.confirmPasswordTF.borderWidth = 0
//                   
//                   self.passwordTF.placeholderColor = AppColor.orangeColor
//                   let count = (self.passwordTF.text ?? "").count
//
//                   self.erroViewDisplay(false, message:count == 0 ? AlertMessage.emptyPassword : AlertMessage.limitPassword)
//                   self.passwordTF.becomeFirstResponder()
//               case .passMismatch:
//                   self.passwordTF.borderColor = AppColor.orangeColor
//                   self.passwordTF.borderWidth = 2
//                   self.confirmPasswordTF.borderColor = AppColor.orangeColor
//                   self.confirmPasswordTF.borderWidth = 2
//
//                   self.erroViewDisplay(false, message: AlertMessage.passwordMismatch)
//               default:
//                   self.confirmPasswordTF.borderColor = AppColor.orangeColor
//                   self.confirmPasswordTF.borderWidth = 2
//                   self.passwordTF.borderColor = UIColor.clear
//                   self.passwordTF.borderWidth = 0
//                   self.confirmPasswordTF.placeholderColor = AppColor.orangeColor
//                   let count = (self.confirmPasswordTF.text ?? "").count
//
//                   self.erroViewDisplay(false, message:count == 0 ? AlertMessage.emptyConPassword : AlertMessage.limitConPassword)
//                   self.confirmPasswordTF.becomeFirstResponder()
//               }
           }
        }
    }
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        self.errorView.isHidden = isShow
        self.errorLabel.text = message
    }

}
