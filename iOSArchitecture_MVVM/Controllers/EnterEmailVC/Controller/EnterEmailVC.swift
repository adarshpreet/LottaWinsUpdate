//
//  EnterEmailVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 08/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class EnterEmailVC: BaseViewController {

    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    var UserInfoDict = KeyValue()
    
    lazy var viewModel: EnterEmailVM = {
        let obj = EnterEmailVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
      @IBAction func btnContinueAction(_ sender: Any) {
          self.emailTF.resignFirstResponder()
          let validity = self.viewModel.validateEmail(self.emailTF.text ?? "")
          if validity.isValid {
              errorView.isHidden = true
              UserInfoDict.updateValue(self.emailTF.text ?? "", forKey: DefaultKeys.Email)
                          
              self.viewModel.socialSignup(social_provider: UserInfoDict[DefaultKeys.SocialProvider] as? String ?? "", social_id: UserInfoDict[DefaultKeys.SocialID] as! String, email: self.emailTF.text ?? "") { (isSuccess, message) in
                  
                  if isSuccess {
                       Helper.shared.lastLogin(LoginKeys(rawValue: self.UserInfoDict[DefaultKeys.SocialProvider] as? String ?? "") ?? .Apple)
                      
                      guard let userSess = UserSession.userInfo else { return }
                      
                      if let isVerifiedEmail = userSess.is_verified, isVerifiedEmail {
                          DispatchQueue.main.async {
                              Helper.shared.rootViewAfterSession()
                          }
                      } else {
                          DispatchQueue.main.async {
                              self.performSegue(withIdentifier: Segues.verifyEmailSegue, sender: self)
                          }
                      }
                  } else {
                      let configAlert: AlertUI = ("Alert", message)
                      UIAlertController.showAlert(configAlert)
                  }
              }
          } else {
              errorView.isHidden = false
              errorLabel.text = validity.error
          }
      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          
          if segue.identifier == Segues.verifyEmailSegue {
              guard let destination = segue.destination as? VerificationEmailVC else { return }
              destination.viewModel.bitmojiURL = UserInfoDict[DefaultKeys.Bitmoji] as? String ?? ""
          }
      }
      
}

extension EnterEmailVC : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //we are stopping the space.
        if (string == " ") || string.rangeOfCharacter(from: .uppercaseLetters) != nil {
            return false
        }
        return true
    }
}


