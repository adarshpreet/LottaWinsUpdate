//
//  UserNameView.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/25/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class UserNameView: UIView {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var doneBtn: CustomButton!
    @IBOutlet weak var usernamTF: CustomTextField!
    @IBOutlet weak var userNameFillTF: CustomTextField!
    override init(frame: CGRect) {
          super.init(frame: frame)
          registerNib()
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
      }

      func registerNib() {
       
          let myView = Bundle.main.loadNibNamed(self.className, owner: self, options: nil)![0] as! UIView
          myView.frame = bounds
          addSubview(myView)
        
          self.doneBtn.isHighlighted = false
      }

}

extension UserNameView: UITextFieldDelegate {
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText:String = textField.text else {return true}
        let newCount:Int = currentText.count + string.count - range.length
        
        //we are stopping the space.
        if (string == " ") {
            return false
        }
        if (self.errorLabel.text ?? "").count > 0 && newCount > 0 && newCount < 18 {
            self.usernamTF.borderColor = UIColor.clear
            self.usernamTF.borderWidth = 0
            self.errorLabel.text = ""
        }
    
       self.isSelectedBTN(newCount > 3)
       return true
   }
    
    func isSelectedBTN(_ isEnable: Bool) {
        self.doneBtn.backgroundColor = isEnable ? AppColor.greenColor : AppColor.grayColor
    }

}
