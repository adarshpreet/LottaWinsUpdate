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
    
    static let faq                   = "https://lottawins.app/privacy-policy/"

    // All end points will be here
    static let login                   = "auth/login/"
    
    static let forgotPassword          = "auth/password/forgot/"
    
    static let generateNewPassword      = "auth/password/reset/"
    
    static let verifyTempPassword      = "auth/password/temp/"

    static let registerUser            = "auth/signup/"
    static let loginUser            = "auth/otp/login/"

    static let resendVerifyEmail       = "auth/resend/email/verify/"
    
    static let regenerateOTPCode       = "auth/signup/otp/resend/"

    static let verifyOTPCode           = "auth/signup/otp/verify/"
    static let verifyLoginOTPCode           = "auth/login/otp/verify/"

    static let createUsername          = "auth/otp/username/"

    static let getuserProfile          = "profile/"
    
    static let checkUsername           = "/auth/check/username/"
    
    static let checkEmail                = "/auth/check/email/"
    
    static let socketURL                 = "ws://34.193.203.207/connect/?"
    
    static let chatSocketURL             = "ws://34.193.203.207/connect/"

    static let resendTemporaryPassword   = "auth/password/temp/resend/"
    
    static let refreshToken              = "/token/refresh"
    
    static let enableSettings            = "profile/settings/"
    
    static let getAllTickets             = "/profile/tickets/"
    
    static let giveawayList              = "giveaways/"
    
    static let createTicket              = "/tickets/"
    
    static let getSponsoredContent       = "sponsored-content/"

    static let getQuizLists              = "quiz/"
    
    static let increaseCoins             = "update/coins/"
    
    static let watchAdmobs               = "?video_watched=true"
    
    static let applyReferralCode         = "profile/apply/invite/code/"

    static let sendMessage               = "chat/"
    
    static let readProfile               = "profile/"

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
    static let dob = "dob"
    static let tokenKey = "token="
    static let profilePic  = "profile_pic"
    static let profileNameConstant  = "imageFile.jpg"
    static let messageSocketKey   = "message"
    static let enableNotification = "enable_notification"
    static let enableLocation = "enable_location"
    static let is_skipped = "is_skipped"
    static let giveAwayId = "giveAwayId"
    static let sponsoredContentID    = "sponsored_content_id"
    static let giveaway_id    = "giveaway_id"
    static let answer    = "answer"
    static let quiz_id    = "quiz_id"
    static let giveaway = "giveaway"
    static let message = "message"

}

enum SocketEnum : String {
    case emailVerified = "emailConfirmed"
    case none
}
