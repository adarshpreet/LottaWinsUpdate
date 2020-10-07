//
//  PopControllerVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/3/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PopControllerVM: BaseViewModel {

    var userService: UserServiceProtocol
    var giveAwayDetail: GiveAwayDetail? // This variable will hold the memory of give Away detail
        
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
       self.userService = userService
    }
    
    func validate(_ referralCode: String?) {
        
        guard let code = referralCode, code.count > 0 else {
            self.isValidationFailed = .invalidReferralCode
            return
        }
        
        self.applyReferralCode(code)
    }
    
    private func applyReferralCode(_ code: String) {
        
        self.isLoading = true
        let parameter = [Keys.otpCode: code]
        
        self.userService.applyReferralCode(parameter) { (result) in
           self.isLoading = false
              switch result {
              case .success(let data):
                if let profile = data as? UserProfile {
                    self.giveAwayDetail?.coins = profile.coins
                }
                self.redirectClosure?("giveAwayDetail")

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
