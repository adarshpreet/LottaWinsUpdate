//
//  AppDelegate.swift
//  EmployeeHealth
//
//  Created by Surjeet Singh on 14/03/2019.
//  Copyright © 2019 Surjeet Singh. All rights reserved.
//

import UIKit
import CoreData
import SCSDKLoginKit
import FirebaseCrashlytics
import CoreLocation
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var onMessage: SwiftCallBacks.handler?
    var onError: SwiftCallBacks.handler?
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Helper.shared.setUpApp()

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print(SwiftSockets.shared.isConnected)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.shouldConnectSocket()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SCSDKLoginClient.application(app, open: url, options: options)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    func shouldConnectSocket() {
        
        //check user is in the session otherwise return the user
        guard self.checkUserSession else {
            return
        }
        
        // if socket is not connected then we will try it to connect the socket again
        guard SwiftSockets.shared.isConnected == false else {
            return
        }
        
        SwiftSockets.shared.connectSocket()
    }
    
    var checkUserSession : Bool {
        return UserSession.userInfo != nil
    }
}

extension AppDelegate {
    
    func initMediaForSilentMode() {
             
         //videos sound must be off by default
        Helper.shared.volumeSet = 0.0
         
         //Below code is for to play the video in silent mode also
         AVAudioSession.sharedInstance().addObserver(self, forKeyPath: DefaultKeys.volumeKey, options: NSKeyValueObservingOptions.new, context: nil)

         do {
             try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .moviePlayback, options: .mixWithOthers)
             try AVAudioSession.sharedInstance().setActive(true)
         } catch {
             print(error.localizedDescription)
         } // end of play the video in silent mode also
      }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case DefaultKeys.volumeKey:
            guard let dict = change, let temp = dict[NSKeyValueChangeKey.newKey] as? Float, temp != 0.5 else { return }
            Helper.shared.volumeSet = temp
            debugPrint("Either volume button tapped.")
        default:
            break
        }
    }
    
}
