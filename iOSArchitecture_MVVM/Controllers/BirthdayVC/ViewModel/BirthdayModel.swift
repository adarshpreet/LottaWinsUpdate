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
    var userModel: UserProfile?
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    /// - Parameter dd: User birthdate day
    /// - Parameter mm: User birthdate month
    /// - Parameter yyyy: User birthdate year
    // User birthdate to check whether its valid or not.
    func validateBirthday(_ dd: String, mm: String, yyyy: String) -> (isValid: Bool, error: String?, date: String) {
        if (dd != "" && mm != "" && yyyy != "") {
            
            let year = Int(yyyy) ?? 0
            guard self.checkDayIsExist(year: year, month: Int(mm) ?? 0, day: Int(dd) ?? 0) else {
                return (false, AlertMessage.invalidDate, "")
            }
            
//            guard year < 18 else { return (false, AlertMessage.invalidDate, "") }
            
            let strDate = yyyy + "-" + mm + "-" + dd
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = ConstantKeys.dateFormat
            if let date = dateFormatter.date(from:strDate) {
                if date < Date()  {
                    return (true, nil, dateFormatter.string(from: date))
                } else {
                    return (false, AlertMessage.futureDate, "")
                }
            } else {
                return (false, AlertMessage.invalidDate, "")
            }
        } else {
            return (false, AlertMessage.emptyDate, "")
        }
    }
    
    func checkDayIsExist(year:Int,month:Int,day:Int) -> Bool {

       let dateComponents = DateComponents(year: year, month: month)
       let calendar = Calendar.current
       guard let date = calendar.date(from: dateComponents) else { return false}

       guard let numberOfDays = calendar.range(of: .day, in: .month, for: date) else { return false }
       return numberOfDays.count >= day
    }
    
    //
    /// Save Birthday Service Function
    /// - Parameter date: User Birthdate
    func saveBirthdayService(_ date: String, completion: @escaping ResponseBlock) {
        
        let parameter = [Keys.dob: date] as KeyValue
        self.isLoading = true
        let file = File(name: "", filename: "", data: nil)
        self.userService.saveBirthdate(parameter, files: file) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? UserProfile else { return }
                UserSession.userInfo = model
                self.userModel = model
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
