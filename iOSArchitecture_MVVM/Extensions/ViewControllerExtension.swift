//
//  ViewControllerExtension.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/7/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import Photos

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element {
        return reduce(.zero, +)
    }
}

extension UIViewController {
    
    func cameraAccess(completionHandler handler: @escaping (Bool) -> Void) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
               //already authorized
            handler(true)
        } else {
           AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
               if granted {
                   //access allowed
                   handler(true)
               } else {
                   handler(false)
               }
           })
        }
    }
       
    func checkPhotoLibraryPermission(completionHandler handler: @escaping (Bool) -> Void) {
       let status = PHPhotoLibrary.authorizationStatus()
       switch status {
       case .authorized:
       //handle authorized status
           handler(true)

       case .denied, .restricted :
       //handle denied status
           handler(false)

       case .notDetermined:
           // ask for permissions
           PHPhotoLibrary.requestAuthorization { status in
               switch status {
               case .authorized:
               // as above
                   handler(true)
               case .denied, .restricted:
               // as above
                   handler(false)
               case .notDetermined:
                   // won't happen but still
                   handler(false)
               @unknown default:
                handler(false)
            }
           }
       @unknown default:
          handler(false)
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}


extension UIView {
    
    func pathZigZagForView() ->UIBezierPath {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let givenFrame = self.frame
        let zigZagWidth = CGFloat(7)
        let zigZagHeight = CGFloat(5)
        var yInitial = height-zigZagHeight
        
        let zigZagPath = UIBezierPath(rect: givenFrame.insetBy(dx: 5, dy: 5))
        zigZagPath.move(to: CGPoint(x:0, y:0))
        zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))
        
        var slope = -1
        var x = CGFloat(0)
        var i = 0
        while x < width {
            x = zigZagWidth * CGFloat(i)
            let p = zigZagHeight * CGFloat(slope) - 5
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }
        
        zigZagPath.addLine(to: CGPoint(x:width,y: 0))
        
        yInitial = 0 + zigZagHeight
        x = CGFloat(width)
        i = 0
        while x > 0 {
            x = width - (zigZagWidth * CGFloat(i))
            let p = zigZagHeight * CGFloat(slope) + 5
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }
        zigZagPath.close()
        return zigZagPath
    }
    
    func applyZigZagEffect(_ backgroundColor:UIColor, fillColor: UIColor) {
        let shapeLayer = CAShapeLayer(layer: self.layer)
        self.backgroundColor = backgroundColor
        shapeLayer.path = self.pathZigZagForView().cgPath
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.masksToBounds = true
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 3
        
        self.layer.addSublayer(shapeLayer)
    }
    
}
