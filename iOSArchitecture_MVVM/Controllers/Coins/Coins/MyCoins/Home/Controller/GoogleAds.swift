//
//  GoogleAds.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/29/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GoogleAds: NSObject {
    static let shared = GoogleAds() // Create the instance of Google Ads
    var finish:SwiftCallBacks.callBack?
    var interstitial: GADInterstitial! // create the instance of GADInterstitial
    
    // MARK:- Initialize the Google Ads
    func initialize() {
        self.interstitial = self.createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
      let interstitial = GADInterstitial(adUnitID:AppKeys.googleAdID)
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
}

extension GoogleAds : GADInterstitialDelegate {
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("interstitialDidDismissScreen")
        self.finish?()
        self.initialize()
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }
}
