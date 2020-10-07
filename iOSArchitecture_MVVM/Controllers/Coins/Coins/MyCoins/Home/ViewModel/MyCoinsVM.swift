//
//  MyCoinsVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 26/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class MyCoinsVM: BaseViewModel {

    var userService: UserServiceProtocol
    
    var currentSponsorIndex = 0
    
    var createTicketResponse : CreateTicketModel? {
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("showTicketDetail")
            }
        }
    }
    
    var giveAwayDetail: GiveAwayDetail? { // This variable will hold the memory of give Away detail
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("giveAwayDetail")
            }
        }
    }
    
    var sponsoredList : [SponsoredContent]? {
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("sponsoredContent")
            }
        }
    }
    
    
    var quizList : [QuizListModel]? {
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("quizList")
            }
        }
    }

    var singleGiveAway : GiveAwayListBase?

    // MARK: Initialization
     // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
     init(userService: UserServiceProtocol) {
        self.userService = userService
     }
    
    // MARK: Api Methods
    func createTicket(_ lotteryNumber: [Int]) {
        
          self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }

        self.userService.createTickets([Keys.otpCode:lotteryNumber], giveAwayID) { (result ) in
            self.isLoading = false
            switch result {
            case .success(let data):
                self.isSuccess = true
                //self.alertMessage = "Your Ticket has been submitted successfully"
                guard let model = data as? CreateTicketModel else { return }
                self.createTicketResponse = model
                self.reloadListViewClosure?()
            case .error(let message):
                self.isSuccess = false
                self.errorMessage = message
            case .customError(let errorModel):
                if let list = errorModel.message?.message {
                    self.serverValidations = list[0]
                }
                break
            }
        }
    }
    
    func fetchGiveAwayDetail() {
        
        self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }
        let parameter = [Keys.giveAwayId: giveAwayID]
        
        self.userService.giveAwayDetail(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(let data):
                guard let model = data as? GiveAwayDetail else { return }
                self.giveAwayDetail = model
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
    
    func fetchSponsoredContent() {
        
        self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }
        let parameter = [Keys.giveAwayId: giveAwayID]
        
        self.userService.getSponsoredContents(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(let data):
                guard let model = data as? [SponsoredContent] else { return }
                self.sponsoredList = model
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
    
    func fetchQuizLists() {
        
        self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }
        let parameter = [Keys.giveAwayId: giveAwayID]
        
        self.userService.getGiveAwayQuizs(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(let data):
                guard let model = data as? [QuizListModel] else { return }
                self.quizList = model
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
    
    
    func increaseSponsoredCoins(content: SponsoredContent?) {
        
        self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }
        
        let parameter = [Keys.giveaway_id: giveAwayID, Keys.sponsoredContentID: content?.id ?? 0]
        
        self.userService.increaseCoins(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(let data):
                self.currentSponsorIndex += 1
                guard let model = data as? GiveAwayDetail else { return }
                self.giveAwayDetail = model
                
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
    
    
    func increaseAdMobCoins() {
        
        self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }
        
        let parameter = [Keys.giveaway_id: giveAwayID]
        
        self.userService.increaseAdMobCoins(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(let data):
               
                guard let model = data as? GiveAwayDetail else { return }
                self.giveAwayDetail = model
                
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
