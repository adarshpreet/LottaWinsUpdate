//
//  EnterEmailVM.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 08/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class EnterEmailVM: BaseViewModel {
    // MARK: Variables
    var userService: UserServiceProtocol
    var userModel: UserProfile?
    var isValidUsername = true
    var isValidEmail = true
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func validateEmail(_ email: String) -> (isValid: Bool, error: String?) {
         if (email != "") {
             if email.isValidEmail() {
                 return (true, nil)
             }
             else {
                 return (false, AlertMessage.invalidEmail)
             }
         }
         else {
             return (false, AlertMessage.emptyEmail)
         }
     }
     
     func socialSignup(social_provider: String,  social_id: String,  email: String, completion: @escaping ResponseBlock) {
         
         let parameter = [DefaultKeys.SocialProvider: social_provider,
                          DefaultKeys.SocialID: social_id,
                          DefaultKeys.Email: email] as KeyValue
         self.isLoading = true
         
         self.userService.SocialSignup(parameter) { (result) in
             self.isLoading = false
             switch result {
             case .success(let data):
                 guard let model = data as? UserBaseModel else { return }
                 if let token = model.token {
                     UserSession.userToken = token
                     if let profile = model.profile {
                         UserSession.userInfo = profile
                         self.userModel = profile
                     }
                 }
                 Helper.shared.setSession()
                 completion(true, "")
             case .error(let message):
                 completion(false, message)
             case .customError(let errorModel):
                 if let message = errorModel.message?.message {
                     completion(false, message[0])
                 }
             }
         }
     }
}
