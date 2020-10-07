//
//  LoginUsernameVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class LoginUsernameVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    var isValidUsername = true

    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
       

    func validation(_ userName: String?, password: String?) {
        
        guard let name = userName, name.count > 0, name.count < 18 else {
            self.isValidationFailed = .username
            return
        }
        
        guard let userPass = password, userPass.count > 6 else {
      //     self.isValidationFailed = .password
           return
        }
        
        let parameter = [Keys.username: name, Keys.password: userPass] as KeyValue
        self.loginService(parameter)
    }
    
    func loginService(_ params: KeyValue) {
        
        self.isLoading = true
        self.userService.manualLogin(params) { (result) in
           self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? UserBaseModel else { return }
                if let token = model.token {
                    UserSession.userToken = token
                    if let profile = model.profile {
                        UserSession.userInfo = profile
                    }
                }
                Helper.shared.setSession()
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
