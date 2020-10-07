//
//  PhoneSignupModel.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/4/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PhoneSignupModel: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    var phoneNumber: String?
    var countryCode: String?

    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    /// - Parameter phone: User Phone Number to check whether its valid or not.
    func validateNumber(_ phone: String?) {
        
        guard let phoneNumber = phone, phoneNumber.count >= 12 else {
           self.isValidationFailed = .phoneNumberError
            return
        }
        
        self.phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        // Once we add the api functions then we will enable the api code.
      self.sendOTPService(self.phoneNumber ?? "")
    }
    
    //
    /// Send OTP Service Function
    /// - Parameter phoneNumber: User Phone Number
    func sendOTPService(_ phoneNumber: String) {
        self.isLoading = true
        let parameter = [Keys.phoneNumber: phoneNumber, Keys.countryCode:self.countryCode ?? ""]
        self.userService.registerNumber(parameter) { (result)  in
          self.isLoading = false
           switch result {
           case .success( _):
               self.isSuccess = true
           case .error(let message):
               self.isFailed = false
               self.errorMessage = message
            case .customError(let errorModel):
                if let list = errorModel.message?.message {
                  self.serverValidations = list[0]
                }
            }
        }
    }
    
    func validateNumberLogin(_ phone: String?) {
        
        guard let phoneNumber = phone, phoneNumber.count >= 12 else {
           self.isValidationFailed = .phoneNumberError
            return
        }
        
        self.phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        // Once we add the api functions then we will enable the api code.
      self.sendOTPServiceLogin(self.phoneNumber ?? "")
    }
    
    func sendOTPServiceLogin(_ phoneNumber: String) {
        self.isLoading = true
        let parameter = [Keys.phoneNumber: phoneNumber, Keys.countryCode:self.countryCode ?? ""]
        self.userService.loginWithNumber(parameter) { (result)  in
          self.isLoading = false
           switch result {
           case .success( _):
               self.isSuccess = true
           case .error(let message):
               self.isFailed = false
               self.errorMessage = message
            case .customError(let errorModel):
                if let list = errorModel.message?.message {
                  self.serverValidations = list[0]
                }
            }
        }
    }
}

