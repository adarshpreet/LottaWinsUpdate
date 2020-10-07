//
//  CreateUsernameVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/6/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class CreateUsernameVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    
    var phoneNumber: String?
    var countryCode: String?
    var isValidUsername = true
    var isValidEmail = true

     // MARK: Initialization
     // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
     init(userService: UserServiceProtocol) {
         self.userService = userService
     }
    
    
    
    func validateFields(_ userName:String?) {
        
        guard let name = userName, name.count > 0, name.count < 18 else {
        self.isValidationFailed = .username
            return
        }
        
        guard self.isValidUsername else {
           self.isValidationFailed = .username
           return
        }
        self.create(name)
    }
    
    
    private func create(_ username: String) {
        let parameter = [Keys.username: username, Keys.phoneNumber:self.phoneNumber ?? ""]
        self.isLoading = true
        self.userService.createUsername(parameter) { (result) in
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
    
    func checkUsername(_ username: String, completion: @escaping ResponseBlock) {
           
          let parameter = [Keys.username: username]
           self.userService.checkUsername(parameter) { (result) in
               switch result {
               case .success(_):
                self.isValidUsername = true
                   completion(true, "")
               case .error(let message):
                    self.isValidUsername = false
                   completion(false, message)
               case .customError(let errorModel):
                    self.isValidUsername = false
                    if let list = errorModel.message?.message {
                        completion(false, list[0])
                    }
                   break
               }
        }
    }
    
    func checkEmail(_ email: String, completion: @escaping ResponseBlock) {
        
        let parameter = [Keys.email: email]
        self.userService.checkEmail(parameter) { (result) in
            switch result {
            case .success(_):
                self.isValidEmail = true
                completion(true, "")
            case .error(let message):
                self.isValidEmail = false
                completion(false, message)
            case .customError(let errorModel):
                self.isValidEmail = false
                 if let list = errorModel.message?.message {
                     completion(false, list[0])
                 }
                break
            }
        }
    }

}
