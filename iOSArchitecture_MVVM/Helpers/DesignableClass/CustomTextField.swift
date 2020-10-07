//
//  CustomTextField.swift
//  TradeZero
//
//  Created by Amit Verma on 11/14/17.
//  Copyright © 2017 Amit Verma. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {

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
    
    /// Sets the placeholder color
    @IBInspectable public var placeholderColor: UIColor = .lightGray {
       didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    
    public override var placeholder: String? {
        didSet {
            let placeholderStr = placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    
    @IBInspectable public var bottomBorder: CGFloat = 0 {
        didSet {
           borderStyle = .none
            layer.backgroundColor = UIColor.white.cgColor

            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0.0, height: bottomBorder)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 0.0
        }
    }
    
    @IBInspectable public var bottomBorderColor : UIColor = UIColor.clear {
        didSet {

            layer.shadowColor = bottomBorderColor.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: bottomBorder)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 0.0
        }
    }
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }

    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
}


extension CustomTextField {
    func hightLighttextField() {
       self.borderColor = AppColor.ErrorColor
       self.borderWidth = 3
       self.textColor = AppColor.newPlaceholderColor
    }
    
    func clearBorderColor() {
        self.borderColor = .clear
        self.borderWidth = 0
        self.textColor = .white
    }
}
