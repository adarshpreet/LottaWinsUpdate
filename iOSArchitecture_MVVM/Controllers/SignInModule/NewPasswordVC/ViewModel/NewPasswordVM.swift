//
//  ResetPasswordVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class NewPasswordVM: BaseViewModel {
    
    // MARK: Variables
      var userService: UserServiceProtocol

      // MARK: Initialization
      // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
      init(userService: UserServiceProtocol) {
          self.userService = userService
      }
    
    func validations(_ password: String?, confirmPassword: String?) {
        
        guard let userPass = password, userPass.count > 6 else {
          // self.isValidationFailed = .password
           return
        }
       
        guard let userConPass = confirmPassword, userConPass.count > 6 else {
           //self.isValidationFailed = .confirmPass
           return
        }
       
        guard userPass == userConPass else {
          // self.isValidationFailed = .passMismatch
           return
        }
        self.generateNewPassword(password: userPass, conPassword: userConPass)
    }
    
    func generateNewPassword(password: String, conPassword: String) {
        
        let parameter = [Keys.password: password, Keys.confirmPassword:conPassword]
         self.isLoading = true
         self.userService.createNewPassword(parameter) { (result) in
            self.isLoading = false
             switch result {
             case .success(_):
                 self.isSuccess = true
             case .error(let message):
                 self.errorMessage = message
             case .customError(let errorModel):
                if let list = errorModel.message?.message {
                    self.serverValidations = list[0]
                }
               break
             }
         }
    }

}
