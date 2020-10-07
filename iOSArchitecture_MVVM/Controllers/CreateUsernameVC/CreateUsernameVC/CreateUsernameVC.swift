//
//  CreateUsernameVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/6/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class CreateUsernameVC: BaseViewController {
    
    @IBOutlet weak var viewForBck: UIView!
    @IBOutlet weak var userNameTF: CustomTextField!
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var confirmPasswordTF: CustomTextField!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var continueButton: CustomButton!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!

    private let termStr = "Terms of Service"
    private let policyStr = "Privacy Policy"
    private var termText = ""
    
    lazy var viewModel: CreateUsernameVM = {
        let obj = CreateUsernameVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           viewForBck.roundCorners(corners: [.topLeft, .topRight], radius: 40)
       }
    // MARK:- IB Actions
    @IBAction func tapOnContinue(_ sender: Any) {
        self.viewModel.validateFields(self.userNameTF.text)

    }
    
    @IBAction func tapOnSignIn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}


extension CreateUsernameVC : BaseDataSources {
    
    func setUpClosures() {
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
           guard let self = `self` else { return }
           let message = serverMessage ?? ""
           DispatchQueue.main.async {
               self.erroViewDisplay(false, message: message)
               self.continueButton.setTitleColor(UIColor.white, for: .normal)
           }
        }
        
        self.viewModel.updateUI = { [weak self] errortype in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                switch errortype {
                case .username:
//                     self.userNameTF.hightLighttextField()
                    self.continueButton.setTitleColor(UIColor.white, for: .normal)
                     if self.viewModel.isValidUsername == false {
                        self.erroViewDisplay(false, message:AlertMessage.usernameExists)
                     } else {
                        let count = (self.userNameTF.text ?? "").count
                        self.erroViewDisplay(false, message: count == 0 ? AlertMessage.emptyUsername : AlertMessage.limitUsername)
                     }
                     
                     self.userNameTF.becomeFirstResponder()
                    break
//                case .email:
//
//                     self.emailTF.hightLighttextField()
//
//                     if self.viewModel.isValidEmail == false {
//                        self.erroViewDisplay(false, message:AlertMessage.emailExists)
//                     } else {
//                        let count = (self.emailTF.text ?? "").count
//                        self.erroViewDisplay(false, message: count == 0 ? AlertMessage.emptyEmail : AlertMessage.invalidEmail)
//                     }
//                     self.emailTF.becomeFirstResponder()
//                    break
//                case .password:
//                    self.passwordTF.borderColor = AppColor.orangeColor
//                    self.passwordTF.borderWidth = 2
//                    self.confirmPasswordTF.borderColor = UIColor.clear
//                    self.confirmPasswordTF.borderWidth = 0
//
//                    self.passwordTF.placeholderColor = AppColor.orangeColor
//                    let count = (self.passwordTF.text ?? "").count
//
//                    self.erroViewDisplay(false, message:count == 0 ? AlertMessage.emptyPassword : AlertMessage.limitPassword)
//                    self.passwordTF.becomeFirstResponder()
//                case .passMismatch:
//                    self.passwordTF.borderColor = AppColor.orangeColor
//                    self.passwordTF.borderWidth = 2
//                    self.confirmPasswordTF.borderColor = AppColor.orangeColor
//                    self.confirmPasswordTF.borderWidth = 2
//
//                    self.erroViewDisplay(false, message: AlertMessage.passwordMismatch)
                default: break
//                    self.confirmPasswordTF.borderColor = AppColor.orangeColor
//                    self.confirmPasswordTF.borderWidth = 2
//                    self.passwordTF.borderColor = UIColor.clear
//                    self.passwordTF.borderWidth = 0
//                    self.confirmPasswordTF.placeholderColor = AppColor.orangeColor
//                    let count = (self.confirmPasswordTF.text ?? "").count
//
//                    self.erroViewDisplay(false, message:count == 0 ? AlertMessage.emptyConPassword : AlertMessage.limitConPassword)
//                    self.confirmPasswordTF.becomeFirstResponder()
                }
            }
        }
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier:  "SegueAddPHOTO", sender: self)
            }
        }
    }
    
    func errorViewDisplay(_ isShow: Bool, message: String) {
        
        if message.contains("Log In") {
            
            //By Signing up below, you agree to LottaWins
            let formattedText = String.format(strings: ["Log In"],
                                                boldFont: AppFont.MuseoSansCyrl_900(fontSize: 16),
                                                boldColor: AppColor.greenColor,
                                                inString: message,
                                                font: AppFont.MuseoSansCyrl_700(fontSize: 14),
                                                color: UIColor.white)
            self.errorLabel.attributedText = formattedText
            self.errorLabel.numberOfLines = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped1))
            self.errorLabel.addGestureRecognizer(tap)
            self.errorLabel.isUserInteractionEnabled = true
            self.errorLabel.textAlignment = .center
            
        } else {
            self.errorLabel.text = message
        }
        self.errorView.isHidden = isShow
    }
    
    @objc func handleTermTapped1(gesture: UITapGestureRecognizer) {
          let finalString = self.errorLabel.text ?? ""
          let termString = finalString as NSString
          let termRange = termString.range(of: "Log In")
          
          let tapLocation = gesture.location(in: errorLabel)
          let index = errorLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
          
          if checkRange(termRange, contain: index) == true {
              self.navigationController?.popToRootViewController(animated: true)
              return
          }
    }
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        self.errorView.isHidden = isShow
        self.errorLabel.text = message
        self.continueButton.setTitleColor(AppColor.grayNewColor, for: .normal)

    }
    
    func setUpView() {
        self.termText = "By Signing up below, you agree to LottaWins \n \(termStr) and \(policyStr)"
        self.setupTapLabel()
        self.setUpClosures()
    }
    
    func setupTapLabel() {
           //By Signing up below, you agree to LottaWins
           let formattedText = String.format(strings: [termStr, policyStr],
                                             boldFont: AppFont.AvenirNext(fontSize: 14),
                                             boldColor: AppColor.newBlueColor,
                                             inString: termText,
                                             font: AppFont.AvenirNext(fontSize: 12),
                                             color:AppColor.newBlueColor)
           self.termsLabel.attributedText = formattedText
           self.termsLabel.numberOfLines = 0
           let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
           self.termsLabel.addGestureRecognizer(tap)
           self.termsLabel.isUserInteractionEnabled = true
           self.termsLabel.textAlignment = .center
    }
       
    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
       let termString = termText as NSString
       let termRange = termString.range(of: termStr)
       let policyRange = termString.range(of: policyStr)
       
       let tapLocation = gesture.location(in: termsLabel)
       let index = termsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
       
       if checkRange(termRange, contain: index) == true {
           handleViewTermOfUse()
           return
       }
       
       if checkRange(policyRange, contain: index) {
           handleViewPrivacy()
           return
       }
    }
       
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
       
    func handleViewTermOfUse() {
       if let vc = self.webViewController() as? WebViewVC {
           vc.currentWebPage = .termsCondition
           let navVC = UINavigationController(rootViewController: vc)
           navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
           self.present(navVC, animated: true, completion: nil)
       }
    }
   
    func handleViewPrivacy() {
       if let vc = self.webViewController() as? WebViewVC {
           vc.currentWebPage = .privacyPolicy
           let navVC = UINavigationController(rootViewController: vc)
           navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
           self.present(navVC, animated: true, completion: nil)
       }
    }
}

extension CreateUsernameVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText:String = textField.text else {return true}
        let newCount:Int = currentText.count + string.count - range.length
        let finaltext = currentText + string
        
        //we are stopping the space.
        if (string == " ") {
            self.continueButton.setTitleColor(AppColor.grayNewColor, for: .normal)

            return false
        }
        
//        switch textField {
//        case self.userNameTF:

            if errorView.isHidden == false && newCount > 0 && newCount < 18 {
//                self.userNameTF.borderColor = UIColor.clear
//                self.userNameTF.borderWidth = 0
                self.continueButton.setTitleColor(AppColor.grayNewColor, for: .normal)
                self.erroViewDisplay(true, message:"")
            }
            else{
                self.continueButton.setTitleColor(UIColor.white, for: .normal)

            }
        if string == ""{
             self.continueButton.setTitleColor(AppColor.grayNewColor, for: .normal)
        }
//        case self.emailTF:
//
//            if errorView.isHidden == false && finaltext.isValidEmail()  {
//               self.emailTF.borderColor = UIColor.clear
//               self.emailTF.borderWidth = 0
//               self.erroViewDisplay(true, message:"")
//           }
//        case self.passwordTF:
//            if errorView.isHidden == false && newCount > 0 && self.confirmPasswordTF.text!.count == 0 {
//                self.passwordTF.borderColor = UIColor.clear
//                self.passwordTF.borderWidth = 0
//                self.erroViewDisplay(true, message:"")
//            } else if self.confirmPasswordTF.text! == finaltext {
//                self.checkMatchPassword()
//            }
//        default:
//            if errorView.isHidden == false && newCount > 0 && self.passwordTF.text!.count == 0 {
//                self.confirmPasswordTF.borderColor = UIColor.clear
//                self.confirmPasswordTF.borderWidth = 0
//                self.erroViewDisplay(true, message:"")
//            } else if self.passwordTF.text! == finaltext {
//                self.checkMatchPassword()
//            }
//        }
        return true
    }
    
    func checkMatchPassword() {
        self.passwordTF.borderColor = UIColor.clear
        self.passwordTF.borderWidth = 0
        self.confirmPasswordTF.borderColor = UIColor.clear
        self.confirmPasswordTF.borderWidth = 0
        self.erroViewDisplay(true, message:"")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case userNameTF:
            if let usernameText = self.userNameTF.text, usernameText.isUsername {
                //call Api
                self.userNameTF.isLoading = true
                self.viewModel.checkUsername(usernameText) { (isSuccess, message) in
                    DispatchQueue.main.async {
                      self.userNameTF.isLoading = false
                        if !isSuccess {
                          //  self.signInBtn.isHidden = false
//                            self.userNameTF.hightLighttextField()
                            self.erroViewDisplay(false, message: message)
                        } else {
                          //  self.signInBtn.isHidden = true
//                            self.userNameTF.clearBorderColor()
                        }
                    }
                }
            }
            
        case emailTF:
            if let emailText = self.emailTF.text, emailText.isValidEmail()  {
                //call Api
                self.viewModel.checkEmail(emailText) { (isSuccess, message) in
                    if !isSuccess {
//                        self.signInBtn.isHidden = false
//                        self.emailTF.hightLighttextField()
                        self.errorViewDisplay(false, message: message)
                    } else {
//                        self.signInBtn.isHidden = true
                        self.emailTF.clearBorderColor()
                    }
                }
            }
            break
        default:
            break
        }
    }

}

extension String {
    
    var isUsername: Bool {
        return self.count > 6 && self.count < 18
    }

    var isValidUserName: Bool {
       let RegEx = "^[0-9a-zA-Z\\_]{7,18}$"
       let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
       return Test.evaluate(with: self)
    }
}
