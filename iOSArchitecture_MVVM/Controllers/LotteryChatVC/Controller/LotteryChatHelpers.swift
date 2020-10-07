//
//  LotteryChatHelpers.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/5/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import UIKit


extension LotteryChatVC {
    
    /// We are reloading the inserting a new message and update the tableview, when ever new message wil comes
    func reloadLastMessage(model: ChatModel) {
           
           // Other User Message Receieved
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
           
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.viewModel.listMessages.append(model)
        let indexpath = IndexPath(row: self.lastIndexPath.row, section: self.lastIndexPath.section)
        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
        self.tableView.insertRows(at: [indexpath], with: .none)
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tableView.scrollToRow(at: indexpath, at: .bottom, animated: true)
    }
    
    func addObserver() {
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK:- Keyboard Observer
    @objc func keyboardNotification(notification: NSNotification) {
           
        if let userInfo = notification.userInfo {
               
            if let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   
                let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                   
                   if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                       UIView.animate(withDuration: duration) {
                          self.bottomContainerConstraint?.constant = 20.0
                          self.view.layoutIfNeeded()
                       }
                    } else {
                         var newHeight : CGFloat = 0
                         newHeight =  self.isBottom ? (endFrame.size.height) - (20 + 10) : (endFrame.size.height) - 20
                       if newHeight == self.bottomContainerConstraint.constant {
                           return
                       }
                           
                       UIView.animate(withDuration: duration) {
                           self.bottomContainerConstraint?.constant = newHeight
                           var contentOffset:CGPoint = self.tableView.contentOffset
                           contentOffset.y += newHeight
                           self.tableView.contentOffset = contentOffset
                           self.view.layoutIfNeeded()
                       }
                 }
            }
        }
    }
    
    public var isBottom: Bool {
        if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
}


extension LotteryChatVC: UITextViewDelegate {
    
    //MARK:- UITextView Delegate.
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let fontLineHeight = textView.font?.lineHeight ?? 21.0
        
        if ConstantKeys.textViewMaxHeight > (newSize.height + 16) {
            textView.isScrollEnabled = false
            UIView.animate(withDuration: 0.25, animations: {
                
                if newSize.height - fontLineHeight > 20 {
                    
                    let TextViewConstraint = (newSize.height + 16)
                    self.chatContainerHeight.constant = TextViewConstraint
                    
                    DispatchQueue.main.async(execute: {
                        textView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    })
                } else {
                    textView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    self.chatContainerHeight.constant = 50
                }
                
            }, completion: nil)
        } else {
            textView.isScrollEnabled = true
        }
        self.view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let messagetext = ((textView.text ?? "") as NSString).replacingCharacters(in: range, with: text)
        let newString = messagetext.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        textView.textColor = AppColor.newBlueColor
        
        if newString.count > 0 {
//            sendBtn.isEnabled = true
        } else {
//            sendBtn.isEnabled = false
            return text == "" ? true : false
        } // end else.
        
        return true
    }
    
}
