//
//  LoginUsernameVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import FirebaseCrashlytics


class LoginUsernameVC: BaseViewController {
    
    @IBOutlet weak var userNameTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    var handler: SwiftCallBacks.handler?
    lazy var viewModel: LoginUsernameVM = {
        let obj = LoginUsernameVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    
    // MARK:- IB Actions
    @IBAction func tapOnLogin(_ sender: Any) {
        self.viewModel.validation(self.userNameTF.text, password: self.passwordTF.text)
    }
    
    @IBAction func tapOnForgotPassword(_ sender: Any) {
        self.performSegue(withIdentifier: Segues.forgotPassword, sender: self)
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnSignup(_ sender: Any) {
        self.handler?(false)
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

extension LoginUsernameVC: BaseDataSources {
    
    func setUpView() {
        self.setUpClosures()
    }
    
    func setUpClosures() {
        
        self.viewModel.redirectControllerClosure = { [weak self] in
           guard let self = `self` else { return }
           DispatchQueue.main.async {
               self.userNameTF.clearBorderColor()
               self.passwordTF.clearBorderColor()
               Helper.shared.lastLogin(.Username)
               Helper.shared.rootViewAfterSession()
           }
       }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
           guard let self = `self` else { return }
           let message = serverMessage ?? ""
           DispatchQueue.main.async {
               self.userNameTF.hightLighttextField()
               self.passwordTF.hightLighttextField()
               self.erroViewDisplay(false, message: message)
           }
        }
        
        self.viewModel.updateUI = { [weak self] errortype in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                switch errortype {
                case .username:
                     self.userNameTF.borderColor = AppColor.orangeColor
                     self.userNameTF.borderWidth = 2
                     self.userNameTF.placeholderColor = AppColor.orangeColor
                     
                     if self.viewModel.isValidUsername == false {
                        self.erroViewDisplay(false, message:AlertMessage.usernameExists)
                     } else {
                        let count = (self.userNameTF.text ?? "").count
                        self.erroViewDisplay(false, message: count == 0 ? AlertMessage.emptyUsername : AlertMessage.limitUsername)
                     }
                     
                     self.userNameTF.becomeFirstResponder()
                    break
//                case .password:
//                    self.passwordTF.borderColor = AppColor.orangeColor
//                    self.passwordTF.borderWidth = 2
//                    
//                    self.passwordTF.placeholderColor = AppColor.orangeColor
//                    let count = (self.passwordTF.text ?? "").count
//
//                    self.erroViewDisplay(false, message:count == 0 ? AlertMessage.emptyPassword : AlertMessage.limitPassword)
//                    self.passwordTF.becomeFirstResponder()
                default:
                    break
                }
            }
        }
    }
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        self.errorView.isHidden = isShow
        self.errorLabel.text = message
    }
    
}

extension LoginUsernameVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let currentText:String = textField.text else {return true}
           let newCount:Int = currentText.count + string.count - range.length
           
           switch textField {
           case self.userNameTF:
               //we are stopping the space and upper case letters to be inputed
               
               if ((string == " ") || string.rangeOfCharacter(from: .uppercaseLetters) != nil) {
                   return false
               }

               if errorView.isHidden == false && newCount > 0 && newCount < 18 {
                   self.userNameTF.borderColor = UIColor.clear
                   self.userNameTF.borderWidth = 0
                   self.userNameTF.textColor = .white
                   self.erroViewDisplay(true, message:"")
               }
           default:
               if errorView.isHidden == false && newCount > 0 {
                   self.passwordTF.borderColor = UIColor.clear
                   self.passwordTF.borderWidth = 0
                   self.userNameTF.textColor = .white
                   self.erroViewDisplay(true, message:"")
               }
            }
        return true
    }
    
}
