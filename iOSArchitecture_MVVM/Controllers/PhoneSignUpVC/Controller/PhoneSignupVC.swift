//
//  PhoneSignupVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/4/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import ADCountryPicker

class PhoneSignupVC: BaseViewController {
    @IBOutlet weak var phoneNumberTF: CustomTextField!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var getStartedButton: CustomButton!
    @IBOutlet weak var labelForGetStarted: UILabel!
    @IBOutlet weak var viewForBck: UIView!
    
    @IBOutlet weak var buttonForBack: UIButton!
    var isForLogin: Bool = false

    lazy var viewModel: PhoneSignupModel = {
       let obj = PhoneSignupModel(userService: UserService())
       self.baseVwModel = obj
       return obj
   }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.phoneNumberTF.becomeFirstResponder()
        }
    }
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()

           // Call the roundCorners() func right there.
           viewForBck.roundCorners(corners: [.topLeft, .topRight], radius: 40)
       }
    @IBAction func tapOnContinue(_ sender: Any) {
        if (self.isForLogin) {
            self.viewModel.validateNumberLogin(self.phoneNumberTF.text)

        } else {
            self.viewModel.validateNumber(self.phoneNumberTF.text)
        }
    }
    
    @IBAction func tapOnCountryPicker(_ sender: Any) {
        self.openPicker()
    }
    
    @IBAction func tapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let vc = segue.destination as? EnterCodeVC else { return }
        vc.viewModel.phoneNumber = self.viewModel.phoneNumber
        vc.viewModel.countryCode = self.viewModel.countryCode
        vc.viewModel.isForLogin = isForLogin
    }
    

}

extension PhoneSignupVC : BaseDataSources {
    
    func setUpClosures() {
        
        self.viewModel.updateUI = { [weak self] type in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                if type == .phoneNumberError {
                    self.errorView()
                    self.alertLabel.text = AlertMessage.invalidPhoneNumber
                    self.transitionView(self.alertLabel, show: false)
                }
            }
        }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
            guard let self = `self` else { return }
            let message = serverMessage ?? ""
            DispatchQueue.main.async {
                self.errorView()
                self.alertLabel.text = message
                self.transitionView(self.alertLabel, show: false)
            }
        }
        
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let self = `self` else { return }
            self.performSegue(withIdentifier: Segues.otpSegue, sender: self)
        }
        
    }
    
    func setUpView() {
        if (self.isForLogin) {
            labelForGetStarted.text = "Login"
            getStartedButton.setTitle("LOGIN", for: .normal)
            labelForGetStarted.textColor = AppColor.pinkColor
            buttonForBack.setImage(UIImage(named: "icBackRed"), for: .normal)

        } else {
            labelForGetStarted.text = "Get Started"
            getStartedButton.setTitle("GET STARTED", for: .normal)
            labelForGetStarted.textColor = AppColor.newBlueColor
            buttonForBack.setImage(UIImage(named: "icBack"), for: .normal)
        }
        self.getStartedButton.setTitleColor(AppColor.grayNewColor, for: .normal)

        self.hideBackButton()
        self.getCurrentCountryCode()
        self.setUpClosures()
    }
    
    func openPicker() {
        let picker = ADCountryPicker()
        picker.showCallingCodes = true
        picker.forceDefaultCountryCode = false
        picker.searchBarBackgroundColor = UIColor.white
        let pickerNavigationController = UINavigationController(rootViewController: picker)

        picker.didSelectCountryClosure = { name, code in
            let flagImage =  picker.getFlag(countryCode: code)
            self.countryImage.image = flagImage
            let dialingCode =  picker.getDialCode(countryCode: code)
            self.countryLabel.text = dialingCode
            pickerNavigationController.dismiss(animated: true, completion: nil)
            self.viewModel.countryCode = dialingCode
        }
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    func getCurrentCountryCode() {
        let code = (Locale.current as NSLocale).object(forKey: .countryCode) as? String ?? "US"
        let picker = ADCountryPicker()
        let flagImage =  picker.getFlag(countryCode: code)
        self.countryImage.image = flagImage
        self.countryImage.layer.cornerRadius = self.countryImage.frame.height/2
        self.countryImage.clipsToBounds = true
        let dialingCode =  picker.getDialCode(countryCode: code)
        self.countryLabel.text = dialingCode
        self.viewModel.countryCode = dialingCode
    }
}

extension PhoneSignupVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText:String = textField.text else {return true}
         if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil { return false }
         let newCount:Int = currentText.count + string.count - range.length
         let addingCharacter:Bool = range.length <= 0

         if(newCount == 4) {
            if self.phoneNumberTF.backgroundColor != .white {
                self.updateView()
            }
            textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
             return false
         } else if(newCount == 8) {
             textField.text = addingCharacter ? currentText + "-\(string)" : String(currentText.dropLast(2))
             return false
         } else if (newCount == 12) {
            if self.phoneNumberTF.backgroundColor != .white {
                self.updateView()
            }
            self.transitionView(self.alertLabel, show: true)
         } else if newCount == 0 {
            if self.phoneNumberTF.backgroundColor == .white {
                self.errorView()
            }
        }
         if(newCount > 14){
             return false
         }

         return true
    }
    
    func updateView() {
        self.phoneNumberTF.backgroundColor = UIColor.white
        self.phoneNumberTF.textColor = AppColor.newPlaceholderColor
        self.getStartedButton.setTitleColor(AppColor.whiteColor, for: .normal)
        self.phoneNumberTF.borderColor = AppColor.newBlueColor
        self.phoneNumberTF.borderWidth = 3
    }
    
    func errorView() {
        self.phoneNumberTF.borderColor = AppColor.newBlueColor
        self.phoneNumberTF.borderWidth = 3
        self.phoneNumberTF.placeholderColor = UIColor.init(red: 47.0/255.0, green: 26.0/255.0, blue: 85.0/255.0, alpha: 0.5)
        self.phoneNumberTF.placeholder = "Phone Number"
        self.phoneNumberTF.backgroundColor = AppColor.whiteColor
        self.phoneNumberTF.textColor = AppColor.newPlaceholderColor
        self.getStartedButton.setTitleColor(AppColor.grayNewColor, for: .normal)
    }
    
    func transitionView(_ view: UIView, show: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseOut, animations: {
            view.alpha = show ? 0 : 1
        }, completion: { finished in
            view.isHidden = show ? true : false
        })
    }
    
    
    
}


