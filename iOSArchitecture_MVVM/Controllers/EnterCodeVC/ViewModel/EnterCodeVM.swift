//
//  EnterCodeVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/5/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class EnterCodeVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    var userModel: UserProfile?
    
    var phoneNumber: String?
    var countryCode: String?
    var isForLogin: Bool = false
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    
    func validate(_ otp: String?) {
        guard let validOTP = otp, validOTP.count == 4 else {
            return
        }
        if isForLogin{
            self.verifyOTPLoginService(validOTP)
            }
        else{
            self.verifyOTPService(validOTP)
        }
        
        
    }
    
    
    /// Verify OTP on the same Number
    /// - Parameter otp: User receive on their phone number
    func verifyOTPService(_ otp: String) {
        self.isLoading = true
        let parameter = [Keys.phoneNumber: phoneNumber ?? "", Keys.otpCode:otp] as KeyValue
        self.userService.verifyOTP(parameter) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? VerifiedBase else {
                    self.isFailed = false
                    return
                }
                self.isSuccess = model.isVerified ?? true
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                if let list = errorModel.message?.message {
                    self.serverValidations = list[0]
                }
            }
        }
    }
    
    /// Send OTP Service Function
    /// - Parameter phoneNumber: User Phone Number
    func generateOTPService() {
        self.isLoading = true
        let parameter = [Keys.phoneNumber: phoneNumber ?? "", Keys.countryCode:self.countryCode ?? ""] as KeyValue
        self.userService.resendOTP(parameter) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? MessageBase else {
                    self.isFailed = false
                    return
                }
                self.validServerMessage = model.message
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                if let list = errorModel.message?.message {
                    self.serverValidations = list[0]
                }
            }
        }
    }
    
    func generateOTPLoginService() {
           self.isLoading = true
           let parameter = [Keys.phoneNumber: phoneNumber ?? "", Keys.countryCode:self.countryCode ?? ""] as KeyValue
           self.userService.resendOTP(parameter) { (result) in
               self.isLoading = false
               switch result {
               case .success(let data):
                   guard let model = data as? MessageBase else {
                       self.isFailed = false
                       return
                   }
                   self.validServerMessage = model.message
               case .error(let message):
                   self.isSuccess = false
                   self.errorMessage = message
               case .customError(let errorModel):
                   if let list = errorModel.message?.message {
                       self.serverValidations = list[0]
                   }
               }
           }
       }
    
    
    
    func verifyOTPLoginService(_ otp: String) {
        self.isLoading = true
        let parameter = [Keys.phoneNumber: phoneNumber ?? "", Keys.otpCode:otp] as KeyValue
        self.userService.verifyLoginOTP(parameter) { (result) in
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
                self.isSuccess =  true

            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                if let list = errorModel.message?.message {
                    self.serverValidations = list[0]
                }
            }
        }
    }
}
