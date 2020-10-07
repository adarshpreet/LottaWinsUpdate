//
//  BirthdayVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 05/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class BirthdayVC: BaseViewController {

    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var txtDay: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var viewForBck: UIView!
    lazy var viewModel: BirthdayModel = {
        let obj = BirthdayModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenUI()
        
        txtDay.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtMonth.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        txtYear.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Call the roundCorners() func right there.
        viewForBck.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    var isSocialLogin: Bool {
        guard let userInfor = UserSession.userInfo else { return false }
        let name = userInfor.username ?? ""
        let email = userInfor.email ?? ""
        return name == email
    }
    
    func setupScreenUI() {
        
        if self.isSocialLogin {
            self.lblInfo.text = "Hey, when is your birthday?"
        } else {
            guard let userInfor = UserSession.userInfo else { return }
            let name = userInfor.username ?? ""
            self.lblInfo.text = "Hey \(name), when is your birthday?"
        }
        
        txtDay.delegate = self
        txtMonth.delegate = self
        txtYear.delegate = self
        self.hideNavigationBar(true, animated: true)
        self.view.layoutIfNeeded()
        lblError.isHidden = true
        let placeholderColorAttribute = [NSAttributedString.Key.foregroundColor:  UIColor.init(red: 47.0/255.0, green: 26.0/255.0, blue: 85.0/255.0, alpha: 0.5)]
        txtDay.attributedPlaceholder = NSAttributedString(string: ConstantKeys.DD,
                                                          attributes: placeholderColorAttribute)
        txtMonth.attributedPlaceholder = NSAttributedString(string: ConstantKeys.MM,
        attributes: placeholderColorAttribute)
        txtYear.attributedPlaceholder = NSAttributedString(string: ConstantKeys.YYYY,
        attributes: placeholderColorAttribute)
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnContinueClick(_ sender: Any) {

        let validity = self.viewModel.validateBirthday(self.txtDay.text ?? "", mm: self.txtMonth.text ?? "", yyyy: self.txtYear.text ?? "")
        lblError.isHidden = validity.isValid
        lblError.text = validity.error
        
        if (validity.isValid) {
            
            self.view.endEditing(true)
//             self.segueToNotifcationVC()
            self.viewModel.saveBirthdayService(validity.date) { (isSuccess, message) in
                if isSuccess {
                    self.segueToNotifcationVC()
                } else {
                    let configAlert: AlertUI = ("Alert", message)
                    UIAlertController.showAlert(configAlert)
                }
            }
        }
        else{
        }
    }

    private func segueToNotifcationVC() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.enableNotification, sender: self)
        }
    }
}

extension BirthdayVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if (textField == self.txtYear) {
            btnContinue.setTitleColor(AppColor.whiteColor, for: .normal)

            return updatedText.count <= 4
        }
        return updatedText.count <= 2
    }
}

extension BirthdayVC {
    
     @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text
        
        if text?.count == 4 && textField == txtYear {
            txtYear.resignFirstResponder()
        } else if text?.count == 2 {
            switch textField {
            case txtMonth:
                txtDay.becomeFirstResponder()
            case txtDay:
                txtYear.becomeFirstResponder()
            default:
                break
            }
        } else if text?.count == 0 {
               switch textField {
               case txtMonth:
                   txtMonth.becomeFirstResponder()
               case txtDay:
                   txtMonth.becomeFirstResponder()
               case txtYear:
                   txtDay.becomeFirstResponder()
               default:
                   break
               }
          }
    }

}
