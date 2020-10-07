//
//  BaseViewModel.swift
//  eLock
//
//  Created by Surjeet on 19/01/18.
//  Copyright © 2018 Surjeet. All rights reserved.
//

import UIKit

enum AlertType {
    case normal
    case warning
    case error
    case success
    case custom
}

enum CustomAlerts {
//    case email
    case username
//    case password
//    case confirmPass
//    case passMismatch
    case phoneNumberError
    case none
    case serverError
    case invalidReferralCode

}

class BaseViewModel: NSObject {

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?(.success)
        }
    }
    var errorMessage: String? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    var isSuccess: Bool? {
        didSet {
            if isSuccess ?? false {
                self.redirectControllerClosure?()
            }
        }
    }
    var isFailed: Bool? {
        didSet {
            self.showAlertClosure?(.error)
        }
    }
    
    var isValidationFailed:CustomAlerts = .none {
       didSet {
           self.updateUI?(isValidationFailed)
       }
    }
    
    var serverValidations:String? {
       didSet {
        self.serverErrorMessages?(self.serverValidations)
       }
    }
    
    var validServerMessage:String? {
      didSet {
        self.validUIClosures?(self.validServerMessage)
      }
    }
    
    var showAlertClosure: ((_ type: AlertType) -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var reloadListViewClosure: (() -> Void)?
    var redirectControllerClosure: (() -> Void)?
    var updateUI: ((_ type:CustomAlerts)->())?
    var serverErrorMessages: ((_ message: String?) -> Void)?
    var validUIClosures: ((_ message: String?) -> Void)?
    var redirectClosure: ((_ type:String)->())?

}
