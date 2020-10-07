//
//  LeaderBoardVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class LeaderBoardVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol

  
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
      self.userService = userService
    }

}
