//
//  BirthdayModel.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 05/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class BirthdayModel: BaseViewModel {
    // MARK: Variables
    var userService: UserServiceProtocol
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    /// - Parameter dd: User birthdate day
    /// - Parameter mm: User birthdate month
    /// - Parameter yyyy: User birthdate year
    // User birthdate to check whether its valid or not.
    func validateBirthday(_ dd: String, mm: String, yyyy: String) -> (isValid: Bool, error: String?) {
        if (dd != "" && mm != "" && yyyy != "") {
            let strDate = dd + "/" + mm + "/" + yyyy
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            if let date = dateFormatter.date(from:strDate) {
                if date < Date()  {
                     return (true, nil)
                }
                else {
                   return (false, "Future date is not allowed.")
                }
            }
            else {
                return (false, "Please enter valid date.")
            }
        }
        else {
            return (false, "Please enter date.")
        }
    }
    
    //
    /// Save Birthday Service Function
    /// - Parameter date: User Birthdate
    func saveBirthdayService(_ date: String) {
        
    }
}
