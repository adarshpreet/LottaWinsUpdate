//
//  ApiConstant.swift
//  EmployeeHealth
//
//  Created by Surjeet Singh on 15/03/2019.
//  Copyright © 2019 Surjeet Singh. All rights reserved.
//

import UIKit

enum Config {
    // Copy base url here
    #if DEVELOPMENT
    static let baseURL: String = "http://34.193.203.207/"
    #else
    static let baseURL: String = "http://34.193.203.207/"
    #endif
    
    static let faq                   = "https://www.google.com/"

    // All end points will be here
    static let login                   = "auth/login/"
    
    static let forgotPassword          = "auth/password/forgot/"
    
    static let generateNewPassword      = "auth/password/reset/"
    
    static let verifyTempPassword      = "auth/password/temp/"
    
    static let resendTempPassword      = "auth/password/temp/resend/"

    static let registerUser            = "auth/signup/"
    
    static let regenerateOTPCode       = "auth/signup/otp/resend/"

    static let verifyOTPCode           = "auth/signup/otp/verify/"
    
    static let createUsername          = "auth/signup/username/"

    static let getuserProfile          = "profile/"
    
    static let checkUsername           = "/auth/check/username/"
    
    static let checkEmail              = "/auth/check/email/"
    
    static let socketURL                = "ws://34.193.203.207/connect/?"
    
    static let resendVerificationLink      = "auth/password/temp/resend/"
    
    static let refreshToken            = "/token/refresh"

}

enum Keys {
    static let email    = "email"
    static let password = "password"
    static let phoneNumber = "phone_number"
    static let countryCode = "country_code"
    static let socialProvider = "social_provider"
    static let socialId = "social_id"
    static let confirmPassword = "confirm_password"
    static let otpCode = "code"
    static let username = "username"
    static let auth = "Authorization"
    static let jwt = "JWT"
<<<<<<< HEAD
    static let tokenKey = "token="
=======
    static let dob = "dob"
>>>>>>> SocialModuleDev3
}
