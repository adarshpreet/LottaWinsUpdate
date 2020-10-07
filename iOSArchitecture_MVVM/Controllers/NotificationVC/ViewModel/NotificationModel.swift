//
//  NotificationModel.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 06/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation

class NotificationModel: BaseViewModel {
    
    // MARK: Variables
      var userService: UserServiceProtocol
      
      // MARK: Initialization
      // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
      init(userService: UserServiceProtocol) {
          self.userService = userService
      }
    
    func enableNotification(isenableNotification: Bool,  isSkipped: Bool = false) {
//         self.isSuccess = true
        
        self.isLoading = true
        let params = [Keys.enableNotification : isenableNotification, Keys.is_skipped: isSkipped]
          self.userService.enableSettings(params) { (result) in
           self.isLoading = false

              switch result {
              case .success( let data):
                     if let profile = data as? UserProfile {
                        UserSession.userInfo = profile
                     }
                    self.isSuccess = true
                   break
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

}
