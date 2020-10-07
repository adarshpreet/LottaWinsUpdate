//
//  CountDownGiveAwayVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/8/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class CountDownGiveAwayVM: BaseViewModel {
    
    var userService: UserServiceProtocol

    var singleGiveAway :GiveAwayListBase?

    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
       self.userService = userService
    }
    
    func fetchGiveAwayInformation() {
        
        
        
    }
}
