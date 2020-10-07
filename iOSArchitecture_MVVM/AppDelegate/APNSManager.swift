//
//  APNSManager.swift
//  Spotlex
//
//  Created by Mandeep Singh on 2/17/20.
//  Copyright © 2020 Mandeep Singh. All rights reserved.
//
import UIKit
import Foundation
import UserNotifications

extension AppDelegate {

    //MARK:- RegisterNotification -
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
            if (granted) {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            } else {
              // show error if not allowed
                DispatchQueue.main.async {
                    self.NotificationPopup()
                }
            }
        })
    }
    
    private func NotificationPopup() {
        
        let configAlert: AlertUI = (AlertMessage.settingMsg, AlertMessage.enableNotification)

        UIAlertController.showAlert(configAlert, sender: self, actions: AlertAction.Okk, AlertAction.cancel) { (target) in
            
            if target.title == AlertAction.Okk.rawValue {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }
        }
    }

}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     
    }
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        
          if let _ = notification.request.content.userInfo as? [String : AnyObject] {
       
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.hexString
        AppUser.defaults.set(deviceTokenString, forKey: DefaultKeys.pushToken)
        self.onMessage?(deviceTokenString)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
        self.onError?(error)
    }
}
