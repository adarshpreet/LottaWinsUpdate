//
//  CustomImageView.swift
//  Wellness
//
//  Created by Amit Verma on 11/07/19.
//  Copyright © 2019 Amit Verma. All rights reserved.
//

import UIKit


@IBDesignable
class CustomImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
}

@IBDesignable
class CustomBarButtonItem: UIBarButtonItem {

    @IBInspectable
    var scaledHeight: CGFloat = 0 {
        didSet {
            self.image = self.image?.scaleTo(CGSize(width: self.scaledHeight, height: self.scaledWidth))
        }
    }

    @IBInspectable
    var scaledWidth: CGFloat = 0 {
        didSet {
            self.image = self.image?.scaleTo(CGSize(width: self.scaledHeight, height: self.scaledWidth))
        }
    }
}

// MARK: - Used to scale UIImages
extension UIImage {
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
