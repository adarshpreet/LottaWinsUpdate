//
//  LotteryHomeVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 26/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class LotteryHomeVM: BaseViewModel {

    // MARK: Variables
    var userService: UserServiceProtocol
    var listData = [GiveAwayListBase]()
    var giveAwayDetail : GiveAwayDetail?

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
      
      // MARK: Api Methods
      func fetchGiveAwayList() {
        self.isLoading = true
        userService.giveawayListing { (result ) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let lists = data as? [GiveAwayListBase] else { return }
                self.listData = lists
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
                print("Error msg : \(message)")
            case .customError(_):
                break
            }
        }
    }
    
    func enterGiveAway(model: GiveAwayListBase, completion: @escaping ResponseBlock) {
           
       self.isLoading = true
       guard let giveAwayID = model.id else { return }
       
       let parameter = [Keys.giveaway_id: giveAwayID]
       
       self.userService.enterGiveAway(parameter) { (result) in
          self.isLoading = false

             switch result {
             case .success(let data):
               guard let model = data as? GiveAwayDetail else { return }
               self.giveAwayDetail = model
               completion(true, "")
             case .error(let message):
                  completion(false, message)
             case .customError(let errorModel):
                  if let list = errorModel.message?.message {
                    completion(false, list[0])
                  }
                 break
             }
       }
    }
}
