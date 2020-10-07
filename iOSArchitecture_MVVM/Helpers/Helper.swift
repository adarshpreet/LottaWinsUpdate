//
//  SpotlexHelper.swift
//  Spotlex
//
//  Created by Mandeep Singh on 1/9/20.
//  Copyright © 2020 Mandeep Singh. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import Firebase
import GoogleMobileAds

enum PendingVC {
    case photo
    case birthday
    case notification
    case location
    case home
    case none
}

struct Helper {
    
    static var shared = Helper()
    var callBack: SwiftCallBacks.handler?

    func setUpApp() {
        
        UINavigationBar.appearance().barTintColor = AppColor.whiteColor
        UINavigationBar.appearance().tintColor = UIColor.white

        sleep(2)
        self.configureSDKS()
        
        if UserDefaults.standard.bool(forKey: DefaultKeys.isAutoLogin) == true {
            self.rootViewAfterSession()
            AppUser.shared.initMediaForSilentMode()
        }
    }
    
    public var volumeSet : Float {
       get {
           if let value = UserDefaults.standard.value(forKey: DefaultKeys.volumeUpdateKey) as? Float {
               return value
           }
           return 0.0
       } set (newValue) {
           UserDefaults.standard.set(newValue, forKey: DefaultKeys.volumeUpdateKey)
           if let volume = self.callBack {
               volume(newValue as AnyObject)
           }
       }
    }
    
  
    
    private func configureSDKS() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance().clientID = AppKeys.kGoogleClientID
    }
        
    //MARK: set root View of current user session
    
    var checkStatus : PendingVC {
        
        guard let userInfor = UserSession.userInfo else { return .none }
        let isSkippedPhoto = userInfor.is_skipped ?? false
        let birthdayVC = userInfor.dob
        let profile = userInfor.profile_pic
        let isSkippedNotification = userInfor.skipped_notification ?? false
        let notification = userInfor.enable_notification ?? false
        let location = userInfor.enable_location ?? false

        if ((profile == nil) || (profile?.count == 0)) && isSkippedPhoto == false {
            return .photo
        } else if (birthdayVC == nil) || (birthdayVC?.count == 0) {
            return .birthday
        } else if isSkippedNotification == false && notification == false {
            return .notification
        } else if location == false {
            return .location
        } else {
            return .home
        }
    }
    
//    func rootViewAfterSession() {
//
//          let homeStoryboard = UIStoryboard(name: Storyboards.Profile, bundle:nil)
//          guard let navVC = homeStoryboard.instantiateViewController(withIdentifier: Identifiers.mainNavVC) as? UINavigationController else {
//              print("Home VC not found")
//              return
//          }
//
//         navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//         AppUser.shared.window?.rootViewController = navVC
//         AppUser.shared.window?.makeKeyAndVisible()
//    }
    
     func rootViewAfterSession() {

          let homeStoryboard = UIStoryboard(name: Storyboards.main, bundle:nil)
          guard let navVC = homeStoryboard.instantiateViewController(withIdentifier: Identifiers.mainNavVC) as? UINavigationController else {
              print("Home VC not found")
              return
          }

         navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
         guard let list = self.viewControllersList() else { return }
         navVC.viewControllers = list
         AppUser.shared.window?.rootViewController = navVC
         AppUser.shared.window?.makeKeyAndVisible()
    }

    func viewControllersList() -> [UIViewController]? {
        
        let homeStoryboard = UIStoryboard(name: Storyboards.main, bundle:nil)
        let homeStory = UIStoryboard(name: Storyboards.home, bundle:nil)
        guard let homeVC = homeStory.instantiateViewController(withIdentifier: TabBarVC.className) as? TabBarVC else {
             print("Home VC not found")
             return nil
         }
        return [homeVC]
//        switch self.checkStatus {
//        case .none:
//            return nil
//            case .photo:
//                guard let photoVC = homeStoryboard.instantiateViewController(withIdentifier: AddPhotoVC.className) as? AddPhotoVC else {
//                     print("Home VC not found")
//                     return nil
//                 }
//                return [photoVC]
//            case .birthday:
//                guard let birthdayVC = homeStoryboard.instantiateViewController(withIdentifier: BirthdayVC.className) as? BirthdayVC else {
//                     print("Home VC not found")
//                     return nil
//                 }
//                return [birthdayVC]
//            case .notification:
//                guard let homeVC = homeStoryboard.instantiateViewController(withIdentifier: NotificationVC.className) as? NotificationVC else {
//                     print("Home VC not found")
//                     return nil
//                 }
//                return [homeVC]
//            case .location:
//            guard let homeVC = homeStoryboard.instantiateViewController(withIdentifier: LocationVC.className) as? LocationVC else {
//                 print("Home VC not found")
//                 return nil
//             }
//            return [homeVC]
//        default:
//            let homeStory = UIStoryboard(name: Storyboards.home, bundle:nil)
//            guard let homeVC = homeStory.instantiateViewController(withIdentifier: TabBarVC.className) as? TabBarVC else {
//                 print("Home VC not found")
//                 return nil
//             }
//            return [homeVC]
//        }
    }
    
    func destroySession() {
       
       self.removeLocalValues()
       let mainStoryboard = UIStoryboard(name: Storyboards.main, bundle:nil)
       guard let navVC = mainStoryboard.instantiateViewController(withIdentifier: Identifiers.mainNavVC) as? UINavigationController else {
            print("Home VC not found")
            return
        }
        guard let homeVC = mainStoryboard.instantiateViewController(withIdentifier: WelcomeVC.className) as? WelcomeVC else {
            print("Home VC not found")
            return
        }
        navVC.viewControllers = [homeVC]

       navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       navVC.isNavigationBarHidden = false
       AppUser.shared.window?.rootViewController = navVC
       AppUser.shared.window?.makeKeyAndVisible()
    }

    func lastLogin(_ last: LoginKeys) {
        AppUser.defaults.set(last.rawValue, forKey: DefaultKeys.lastLoginOption)
    }
    
    func setSession() {
        UserDefaults.standard.set(true, forKey: DefaultKeys.isAutoLogin)
        UserDefaults.standard.synchronize()
    }
    
    private func removeLocalValues() {
        UserDefaults.standard.set(false, forKey: DefaultKeys.isAutoLogin)
        UserDefaults.standard.synchronize()
        AppUser.defaults.removeObject(forKey: DefaultKeys.isAutoLogin)
        AppUser.defaults.removeObject(forKey: DefaultKeys.session)
        AppUser.defaults.removeObject(forKey: DefaultKeys.userToken)
    }
}

struct UserSession {
    
    static var userInfo : UserProfile? {
        get {
            guard let decoded = UserDefaults.standard.data(forKey: DefaultKeys.session) else { return nil }
            let decoder = JSONDecoder()
            guard let userModel = try? decoder.decode(UserProfile.self, from: decoded) else {
                return nil
            }
            return userModel
        } set {
            guard let value = newValue else { return }
            do {
                let genericModel = try JSONEncoder().encode(value)
                UserDefaults.standard.set(genericModel, forKey: DefaultKeys.session)
                UserDefaults.standard.synchronize()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    static var userToken : String? {
        get {
            guard let decoded  = AppUser.defaults.data(forKey: DefaultKeys.userToken) else { return nil }
            let decoder = JSONDecoder()
            guard let token = try? decoder.decode(String.self, from: decoded) else {
                return nil
            }
            return token
        } set {
            guard let value = newValue else { return }
            do {
                let genericModel = try JSONEncoder().encode(value)
                AppUser.defaults.set(genericModel, forKey: DefaultKeys.userToken)
                AppUser.defaults.synchronize()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
 
}


