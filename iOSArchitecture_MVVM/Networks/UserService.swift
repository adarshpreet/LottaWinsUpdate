//
//  LoginAPIManager.swift
//  iOSArchitecture
//
//  Created by Amit on 23/02/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import Foundation
import UIKit

protocol UserServiceProtocol {
    func doLogin(email: String, password: String, completion:@escaping (Result<Any>) -> Void)
    func resendOTP(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)
    func verifyOTP(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)
    func registerNumber(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)
    func loginWithNumber(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)
    func verifyLoginOTP(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)
    func resendLoginOTP(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)

    func createUsername(_ params: KeyValue, completion:@escaping (Result<Any>) -> Void)
    func uploadProfilePic(_ params: KeyValue, files: File?, completion: @escaping (Result<Any>) -> Void)
    func SocialSignup(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func SocialLogin(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func checkUsername(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func checkEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func manualLogin(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func forgotPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func resendTemporyPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func createNewPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func verifyTemporyPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func saveBirthdate(_ params: KeyValue, files: File, completion: @escaping (Result<Any>) -> Void)
    func resendVerificationEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func enableSettings(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func giveawayListing(completion: @escaping (Result<Any>) -> Void)
    func giveAwayDetail(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func getSponsoredContents(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func getGiveAwayQuizs(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func increaseCoins(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func increaseAdMobCoins(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func applyReferralCode(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func createTickets(_ params: KeyValue, _ ticketID: Int, completion: @escaping (Result<Any>) -> Void)
    func fetchAllTickets(completion: @escaping (Result<Any>) -> Void)
    func enterGiveAway(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func sendChatMessage(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)
    func readProfile(completion: @escaping (Result<Any>) -> Void)
    
    func chatLists(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void)

}

public class UserService: APIService, UserServiceProtocol {
    
    func enableSettings(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.PATCH, Config.enableSettings, true)
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
    
    func resendVerificationEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.resendVerifyEmail, true)
         super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func createNewPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.generateNewPassword, true)
         super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func verifyTemporyPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.verifyTempPassword, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: VerifyTempPassBase.self) { (result) in
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
    
    func resendTemporyPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.resendTemporaryPassword, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func forgotPassword(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.forgotPassword, false)
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func manualLogin(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
       let serviceConfig: Service.config = (.POST, Config.login, false)
       super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserBaseModel.self) { (result) in
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
   
    func doLogin(email: String, password: String, completion: @escaping (Result<Any>) -> Void) {
        let param = [Keys.email: email, Keys.password: password]
           let serviceConfig: Service.config = (.POST, Config.login, false)
           super.startService(config: serviceConfig, parameters: param, files: nil, modelType: User.self) { (result) in
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
    
    func registerNumber(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        
       let serviceConfig: Service.config = (.POST, Config.registerUser, false)
       super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    
    func loginWithNumber(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
           
          let serviceConfig: Service.config = (.POST, Config.loginUser, false)
          super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func createUsername(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.createUsername, false)
         super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserBaseModel.self) { (result) in
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
    
    func uploadProfilePic(_ params: KeyValue, files: File?, completion: @escaping (Result<Any>) -> Void) {
        
        guard let userModel = UserSession.userInfo else { return }
        
        let finalURL = Config.getuserProfile + "\(userModel.id ?? 0)/"
        let serviceConfig : Service.config = (.PATCH, finalURL, true)

        super.startService(config: serviceConfig, parameters: params, files: files == nil ? nil : [files!], modelType: UserProfile.self) { (result) in
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
    
    func verifyOTP(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig: Service.config = (.POST, Config.verifyOTPCode, false)
         super.startService(config: serviceConfig, parameters: params, files: nil, modelType: VerifiedBase.self) { (result) in
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
    
    func SocialSignup(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
                
        let serviceConfig: Service.config = (.POST, Config.registerUser, false)
        
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserBaseModel.self) { (result) in
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
    
    func SocialLogin(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
                
        let serviceConfig: Service.config = (.POST, Config.login, false)
        
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserBaseModel.self) { (result) in
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
    
    func resendOTP(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig : Service.config = (.POST, Config.regenerateOTPCode, false)

        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    
    func resendLoginOTP(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
           let serviceConfig : Service.config = (.POST, Config.regenerateOTPCode, false)

           super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    func verifyLoginOTP(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig : Service.config = (.POST, Config.verifyLoginOTPCode, false)

        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: UserBaseModel.self) { (result) in
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
    
    func checkUsername(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig : Service.config = (.POST, Config.checkUsername, false)

        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func checkEmail(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void) {
        let serviceConfig : Service.config = (.POST, Config.checkEmail, false)

        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: MessageBase.self) { (result) in
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
    
    func saveBirthdate(_ params: KeyValue, files: File, completion: @escaping (Result<Any>) -> Void) {
        
        guard let userModel = UserSession.userInfo else { return }
        let finalURL = Config.getuserProfile + "\(userModel.id ?? 0)/"
        let serviceConfig : Service.config = (.PATCH, finalURL, true)

        super.startService(config: serviceConfig, parameters: params, files: [files], modelType: UserProfile.self) { (result) in
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
    
    func giveAwayDetail(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        guard let paramModel = params else { return }
        let giveAwayID = paramModel[Keys.giveAwayId] as? Int ?? 0
        let finalURL = Config.giveawayList + "\(giveAwayID)/"
        let serviceConfig : Service.config = (.GET, finalURL, true)
               
       super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: GiveAwayDetail.self) { (result) in
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
    
    // TARUN
    func giveawayListing(completion: @escaping (Result<Any>) -> Void) {
        
        let serviceConfig : Service.config = (.GET, Config.giveawayList, true)
        
        super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: [GiveAwayListBase].self) { (result) in
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
    
    // func createTickets(_ params: KeyValue, completion: @escaping (Result<Any>) -> Void)
    func createTickets(_ params: KeyValue, _ ticketID: Int, completion: @escaping (Result<Any>) -> Void) {
        
        let finalURL = Config.giveawayList + "\(ticketID)" + Config.createTicket
        let serviceConfig : Service.config = (.POST, finalURL, true)
        
        super.startService(config: serviceConfig, parameters: params, files: nil, modelType: CreateTicketModel.self) { (result) in
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
    
    func getSponsoredContents(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        
        guard let paramModel = params else { return }
        let giveAwayID = paramModel[Keys.giveAwayId] as? Int ?? 0
        let finalURL = Config.giveawayList + "\(giveAwayID)/" + Config.getSponsoredContent
        let serviceConfig : Service.config = (.GET, finalURL, true)
        
        super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: [SponsoredContent].self) { (result) in
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
    
    func getGiveAwayQuizs(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
        
        guard let paramModel = params else { return }
        let giveAwayID = paramModel[Keys.giveAwayId] as? Int ?? 0
        let finalURL = Config.giveawayList + "\(giveAwayID)/" + Config.getQuizLists
        let serviceConfig : Service.config = (.GET, finalURL, true)
        
        super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: [QuizListModel].self) { (result) in
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
    
    func increaseCoins(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
         
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
    
    func increaseAdMobCoins(_ params: KeyValue?, completion: @escaping (Result<Any>) -> Void) {
           
          let admobURL = Config.increaseCoins + Config.watchAdmobs
          let serviceConfig : Service.config = (.POST, admobURL, true)

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
    
    
    func fetchAllTickets(completion: @escaping (Result<Any>) -> Void) {
        
        guard let userModel = UserSession.userInfo else { return }
        let finalURL = Config.getAllTickets
        let serviceConfig : Service.config = (.GET, finalURL, true)
        
        super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: [AllGeneratedTickets].self) { (result) in
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
    
    func readProfile(completion: @escaping (Result<Any>) -> Void) {
        
        let finalURL = Config.readProfile
        let serviceConfig : Service.config = (.GET, finalURL, true)
        
        super.startService(config: serviceConfig, parameters: nil, files: nil, modelType: UserProfile.self) { (result) in
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


