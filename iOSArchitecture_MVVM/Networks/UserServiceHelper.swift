//
//  UserServiceHelper.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/3/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit


extension UserService {
    
    func applyReferralCode(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        
         let serviceConfig : Service.config = (.POST, Config.applyReferralCode, true)

         super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserProfile.self) { (result) in
             DispatchQueue.main.async {
                 switch result {
                     
                 case .success(let data):
                     if let userModel = data {
                         // Parse Here
                         completion(.success(userModel))
                     }
                 case .error(let message):
                     completion(.error(message))
                 case .customError(let errorModel):
                     completion(.customError(errorModel))
                 }
             }
         }
    }
    
    func enterGiveAway(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
         
        let serviceConfig : Service.config = (.POST, Config.increaseCoins, true)

        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: GiveAwayDetail.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let userModel = data {
                        // Parse Here
                        completion(.success(userModel))
                    }
                case .error(let message):
                    completion(.error(message))
                case .customError(let errorModel):
                    completion(.customError(errorModel))
                }
            }
        }
    }
    
    func sendChatMessage(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        
        let serviceConfig : Service.config = (.POST, Config.sendMessage, true)

        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: ChatModel.self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let userModel = data {
                        // Parse Here
                        completion(.success(userModel))
                    }
                case .error(let message):
                    completion(.error(message))
                case .customError(let errorModel):
                    completion(.customError(errorModel))
                }
            }
        }
    }
    
    func chatLists(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        
        guard let paramModel = params else { return }
        let giveAwayID = paramModel[Keys.giveaway] as? Int ?? 0
        
        var requestStr = ""
        let initialStr = Config.giveawayList + "\(giveAwayID)/" + Config.sendMessage
        if let timeStamp = paramModel["timeStamp"] as? String, timeStamp != "NA" {
            requestStr =  initialStr + "?timestamp=\(timeStamp)&limit=10"
        } else {
            requestStr = initialStr + "?limit=10"
        }
        
        let serviceConfig : Service.config = (.GET, requestStr, true)

        super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: [ChatModel].self) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let userModel = data {
                        // Parse Here
                        completion(.success(userModel))
                    }
                case .error(let message):
                    completion(.error(message))
                case .customError(let errorModel):
                    completion(.customError(errorModel))
                }
            }
        }
    }
}
