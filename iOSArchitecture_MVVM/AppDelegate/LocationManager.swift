//
//  LocationManager.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/7/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension AppDelegate : CLLocationManagerDelegate {
    
     // This function is using for Location Manager serverices and check the authorization status.
    //MARK:- Location Manager Services
    func setupLocationManagerServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        } else {
            self.presentLocationViewController()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let locationInfo = manager.location else {return}

        if locations.count > 0 {
            self.onMessage?(locationInfo.coordinate.latitude)
            print(locationInfo.coordinate.latitude, locationInfo.coordinate.longitude)
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.onError?(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
         self.presentLocationViewController()
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.startUpdatingLocation()
        default:
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func presentLocationViewController() {
        
       let configAlert: AlertUI = (AlertMessage.locationMsg, AlertMessage.locationAccess)

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
