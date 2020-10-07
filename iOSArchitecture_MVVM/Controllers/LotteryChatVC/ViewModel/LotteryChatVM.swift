//
//  LotteryChatVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/4/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class LotteryChatVM: BaseViewModel {
    
    // MARK: Variables
    var chatoffset = 0

    var userService: UserServiceProtocol
    var giveAwayDetail : GiveAwayListBase? {
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("didLoad")
            }
        }
    }
    
    var listMessages = [ChatModel]()
    var newMessage : ChatModel? {
        didSet {
            DispatchQueue.main.async {
                self.redirectClosure?("newMessage")
            }
        }
    }

    init(userService: UserServiceProtocol) {
       self.userService = userService
    }
        
    // MARK:- Initialize Socket
    func initializeWebSocket() {
        guard let chatID = self.giveAwayDetail?.chatID else { return }
        let chatSocketURL = Config.chatSocketURL + chatID + "/?"
        SwiftSockets.shared.initilaize(urlString: chatSocketURL)
        
        SwiftSockets.shared.onConnected = { [weak self] in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                self.redirectClosure?("socketConnected")
            }
        }
       
        SwiftSockets.shared.onMessage = { [weak self] response in
            guard let self = `self` else { return }
            if let dict = response as? KeyValue {
                self.convertJsonToModel(object: dict)
            }
        }
    }
    
    func convertJsonToModel(object: KeyValue) {

        let id = object["user_id"] as? Int
        let message = object["message"] as? String
        let pic = object["image"] as? String
        let messageID = object["message_id"] as? Int
        let created = object["created"] as? String

        let model = ChatModel(id: id, pic: pic, message: message, messageID: messageID, createdAt: created)
        self.newMessage = model
    }
    
    func sendMessage(text: String) {
        guard let giveawayID = self.giveAwayDetail?.id else { return }

        let parameter = [Keys.giveaway: giveawayID, Keys.message: text] as [String : Any]
        self.isLoading = true

        self.userService.sendChatMessage(parameter) { (result) in
           self.isLoading = false

              switch result {
              case .success(_):
                break
//                guard let model = data as? ChatModel else { return }
//                self.newMessage = model
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
    
    func fetchChatLists(_ timeStamp: String? = nil) {
        
        guard let giveawayID = self.giveAwayDetail?.id else { return }
        let parameter = [Keys.giveaway: giveawayID, "timeStamp": timeStamp ?? "NA"] as [String : Any]

        self.userService.chatLists(parameter) { (result) in

             switch result {
             case .success(let data):
                
                guard let model = data as? [ChatModel] else { return }

                if self.chatoffset == 0 {
                    self.listMessages.removeAll()
                    self.listMessages = model
                    self.chatoffset = model.count
                    DispatchQueue.main.async {
                        self.redirectClosure?("newLists")
                    }
                } else {
                    let oldMessages = self.listMessages
                    self.listMessages = model
                    self.listMessages += oldMessages
                    DispatchQueue.main.async {
                        self.redirectClosure?("oldMessages")
                    }
                }
             case .error(let message):
                DispatchQueue.main.async {
                    self.redirectClosure?("errorResponse")
                }
                  // self.errorMessage = message
             case .customError(let errorModel):
                DispatchQueue.main.async {
                    self.redirectClosure?("errorResponse")
                }
//                  if let list = errorModel.message?.message {
//                     self.serverValidations = list[0]
//                  }
                 break
             }
       }
    }
}
