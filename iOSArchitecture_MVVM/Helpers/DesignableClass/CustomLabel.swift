//
//  CustomLabel.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 04/06/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
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
