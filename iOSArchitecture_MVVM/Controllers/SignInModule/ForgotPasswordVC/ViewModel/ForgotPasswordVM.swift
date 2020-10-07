//
//  ForgotPasswordVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class ForgotPasswordVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func validations(_ email: String?) {
        
        guard let validEmail = email, validEmail.count > 0 else {
//            self.isValidationFailed = .email
            return
        }
          
        guard validEmail.isValidEmail() else {
          //  self.isValidationFailed = .email
            return
        }

        self.generateTempPasswordService(validEmail)
    }
    
    private func generateTempPasswordService(_ email: String) {
        self.isLoading = true
        let parameter = [Keys.email: email]
        
           self.userService.forgotPassword(parameter) { (result) in
            self.isLoading = false

               switch result {
               case .success(_):
                    self.isSuccess = true
                    break
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
