//
//  PersonQuizModel.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/2/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class PersonQuizModel: BaseViewModel {
    
    var userService: UserServiceProtocol
    
    var quizModel : [QuizListModel]?
    var singleGiveAway : GiveAwayListBase?
    
    var giveAwayDetail : GiveAwayDetail? {
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("movetoNext")
            }
        }
    }


    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
       self.userService = userService
    }
    
    var items : Int {
        
        guard let model = self.quizModel else { return 0 }
        return model.count
    }
    
    
    func increaseSponsoredCoins(content: QuizListModel, selectedAnswer: String) {
        
        self.isLoading = true
        guard let giveAwayID = self.singleGiveAway?.id else { return }
        guard let quizID = content.id else { return }

        let parameter = [Keys.giveaway_id: giveAwayID, Keys.quiz_id: quizID, Keys.answer : selectedAnswer] as KeyValue
        
        self.userService.increaseCoins(parameter) { (result) in
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
