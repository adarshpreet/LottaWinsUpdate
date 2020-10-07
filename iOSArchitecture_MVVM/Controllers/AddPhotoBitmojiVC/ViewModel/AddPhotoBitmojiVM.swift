//
//  AddPhotoBitmojiVM.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 12/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class AddPhotoBitmojiVM: BaseViewModel {
    
    var isBitMoji = false
    
    // MARK: Variables
    var userService: UserServiceProtocol
    
    // MARK: Initialization
    // Putting dependency injection by paasing the service object in constructor and not giving the responsibility for the same to LoginViewModel
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
        
    // MARK: Services Methods
    func uploadProfilePic(profileImage : UIImage?, isSkipped: Bool) {
        let imageData = profileImage?.jpegData(compressionQuality: 0.1)
        let parameter = [Keys.is_skipped: isSkipped] as KeyValue

        let file = File.init(name:Keys.profilePic, filename:Keys.profileNameConstant, data: imageData)
        self.isLoading = true
        self.userService.uploadProfilePic(parameter, files: isSkipped ? nil : file) { (result)  in
            self.isLoading = false
            switch result {
            case .success(let data):
                guard let model = data as? UserProfile else { return }
                UserSession.userInfo = model
                self.isSuccess = true
            case .error(let message):
                self.errorMessage = message
            case .customError(let model):
                self.errorMessage = model.message?.message?[0]
          }
        }
    }
}
