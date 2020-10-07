//
//  ProfileVM.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class ProfileVM: BaseViewModel {
    
    // MARK: Variables
    var userService: UserServiceProtocol
    var ticketList: [AllGeneratedTickets]?
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    func fetchTickets() {
        self.isLoading = true
        userService.fetchAllTickets { (result ) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let lists = data as? [AllGeneratedTickets] else { return }
                print("LIST OF TICKETS \(lists.count)")
                self.ticketList = lists
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
    
    
    func fetchProfile() {
           self.isLoading = true
           userService.readProfile { (result ) in
               self.isLoading = false
               switch result {
               case .success(let data):
                   if let profile = data as? UserProfile {
                      UserSession.userInfo = profile
                   }
                   self.redirectClosure?("readProfile")
               case .error(let message):
                   self.isSuccess = false
                   self.errorMessage = message
                   print("Error msg : \(message)")
               case .customError(_):
                   break
               }
           }
    }
    
    func validateFields(_ userName:String?) -> (Bool?, String?) {
        guard let name = userName, name.count > 0, name.count < 18 else {
            let check = (userName ?? "").count == 0 ? AlertMessage.emptyUsername : AlertMessage.limitUsername
            return (false, check)
        }
        
        return (true, nil)
    }
    
    func updateUsername(_ username: String, completion: @escaping ResponseBlock) {
        
        let parameter = [Keys.username: username] as KeyValue
        self.isLoading = true
        let file = File(name: "", filename: "", data: nil)
        self.userService.saveBirthdate(parameter, files: file) { (result) in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? UserProfile else { return }
                UserSession.userInfo = model
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
    
    // MARK: Services Methods
    func uploadProfilePic(profileImage : UIImage?, isSkipped: Bool) {
      let imageData = profileImage?.jpegData(compressionQuality: 0.1)
      let parameter = [Keys.is_skipped: isSkipped] as KeyValue

      let file = File.init(name:isSkipped ? nil : Keys.profilePic, filename:Keys.profileNameConstant, data: imageData)
        self.isLoading = true
        self.userService.uploadProfilePic(parameter, files: file) { (result)  in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? UserProfile else { return }
                UserSession.userInfo = model
                self.validServerMessage = "uploadImage"
            case .error(let message):
                self.errorMessage = message
            case .customError(let model):
              self.errorMessage = model.message?.message?[0]
          }
      }
    }

}
