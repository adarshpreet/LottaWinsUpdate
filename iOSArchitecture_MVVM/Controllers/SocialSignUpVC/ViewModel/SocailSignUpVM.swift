//
//  SocailSignUpVM.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 07/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class SocailSignUpVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    var userModel: UserProfile?

    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
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
    
    func socialLogin(social_provider: String, social_id: String, emailId: String = "", completion: @escaping ResponseBlock) {
        
        var params = KeyValue()
        
        if emailId.count > 0 {
            params = [DefaultKeys.SocialProvider: social_provider,
                                    DefaultKeys.SocialID: social_id, DefaultKeys.Email: emailId] as KeyValue
        } else {
            params = [DefaultKeys.SocialProvider: social_provider,
                                               DefaultKeys.SocialID: social_id] as KeyValue
        }
        
        self.isLoading = true
        
        self.userService.SocialLogin(params) { (result) in
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
