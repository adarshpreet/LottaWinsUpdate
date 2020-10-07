//
//  VerificationEmailVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/13/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class VerificationEmailVM: BaseViewModel {

    
    // MARK: Variables
    var userService: UserServiceProtocol
    var bitmojiURL = ""
    var isMoved = false

   
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
       self.userService = userService
    }
    
    func resendVerificationLink() {
        
        guard let email = UserSession.userInfo?.email else {
            print("user email not found at my side.")
            return
        }
        
        self.isLoading = true
        let parameter = [Keys.email: email]
       
          self.userService.resendVerificationEmail(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(let data):
                guard let model = data as? MessageBase else { return }
                self.serverValidations = model.message
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
