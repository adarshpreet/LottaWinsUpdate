//
//  EnterCodeVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/5/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class EnterCodeVC: BaseViewController, BaseDataSources {
    
    @IBOutlet weak var firstTF: CustomTextField!
    @IBOutlet weak var secondTF: CustomTextField!
    @IBOutlet weak var thirdTF: CustomTextField!
    @IBOutlet weak var forthTF: CustomTextField!
    
    @IBOutlet weak var viewForBack: UIView!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var subheadingLabel: UILabel!
    @IBOutlet weak var errorView: UIView! // This is an error view
    @IBOutlet weak var errorLabel: UILabel! // This is an error message label which will display the data

    lazy var viewModel: EnterCodeVM = {
        let obj = EnterCodeVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var otpText : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewForBack.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    
    // MARK:- BaseDataSources Methods
    func setUpClosures() {
        if viewModel.isForLogin{
            self.viewModel.redirectControllerClosure = { [weak self] in
                guard let self = `self` else { return }
                          Helper.shared.lastLogin(.Username)
                          Helper.shared.rootViewAfterSession()
                  }
        }else{
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let self = `self` else { return }
            self.performSegue(withIdentifier: Segues.usernameSegue, sender: self)
            }
            
        }
        
        self.viewModel.validUIClosures = { [weak self] serverMessage in
           guard let self = `self` else { return }
           let message = serverMessage ?? ""
           DispatchQueue.main.async {
               self.erroViewDisplay(false, message: message)
           }
        }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
           guard let self = `self` else { return }
           let message = serverMessage ?? ""
           DispatchQueue.main.async {
               self.alltextfields()
               self.erroViewDisplay(false, message: message)
           }
        }
    }
    
    func alltextfields() {
        nextButton.setTitleColor(AppColor.grayNewColor, for: .normal)

        self.firstTF.hightLighttextField()
        self.secondTF.hightLighttextField()
        self.thirdTF.hightLighttextField()
        self.forthTF.hightLighttextField()
    }
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        errorView.isHidden = false
        self.errorLabel.text = message
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
          // your code with delay
            UIView.animate(withDuration: 0.5) {
                self.errorView.isHidden = true
            }
        }
    }
  
    func setUpView() {
        
        guard let number = self.viewModel.phoneNumber else { return }
        guard let code = self.viewModel.countryCode else { return }
        
        self.subheadingLabel.attributedText = ("Enter the code we sent to \n\(code) \(number.toPhoneNumber())" as NSString).addBoldText(boldPartsOfString: ["\(code) \(number.toPhoneNumber())"], font: AppFont.Nunito(fontSize: 18), boldFont: AppFont.Nunito(fontSize: 18), boldFontcolor: AppColor.ClickBlueColor)
 
//        self.nextButton.isHidden = true
        nextButton.setTitleColor(AppColor.grayNewColor, for: .normal)
        self.setUpClosures()
        
        firstTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        secondTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        thirdTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        forthTF.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.firstTF.becomeFirstResponder()
        if viewModel.isForLogin{
            nextButton.setTitle("Continue", for: .normal)
        }else{
            nextButton.setTitle("NEXT", for: .normal)

        }
    }
    
    // MARK:- IB Actions
    @IBAction func tapOnContinue(_ sender: Any) {
     self.viewModel.validate(self.otpText)
         
      
    }
    
    @IBAction func tapOnReSendCode(_ sender: Any) {
        if viewModel.isForLogin{
        self.viewModel.generateOTPLoginService()
        }
        else{
            self.viewModel.generateOTPService()

        }
    }
       
    @IBAction func tapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let vc = segue.destination as? CreateUsernameVC else { return }
        vc.viewModel.phoneNumber = self.viewModel.phoneNumber
        vc.viewModel.countryCode = self.viewModel.countryCode
    }
    

}

extension EnterCodeVC : UITextFieldDelegate {
    
     @objc func textFieldDidChange(_ textField: UITextField) {
           let text = textField.text
           if text?.count == 1 {
               switch textField {
               case firstTF:
                   secondTF.becomeFirstResponder()
               case secondTF:
                   thirdTF.becomeFirstResponder()
               case thirdTF:
                   forthTF.becomeFirstResponder()
               case forthTF:
                   forthTF.resignFirstResponder()
                   // dismiss keyboard
               default:
                   break
               }
           } else if text?.count == 0 {
               switch textField {
               case firstTF:
                   firstTF.becomeFirstResponder()
               case secondTF:
                   firstTF.becomeFirstResponder()
               case thirdTF:
                   secondTF.becomeFirstResponder()
               case forthTF:
                   thirdTF.becomeFirstResponder()
               default:
                   break
               }
           }
        self.dismissBoard()
    }
    
    func dismissBoard() {
        var isDone = false
        
        isDone = self.firstTF.text!.count > 0 && self.secondTF.text!.count > 0 && self.thirdTF.text!.count > 0 && self.forthTF.text!.count > 0
       
//        self.nextButton.isHidden = !isDone
//        nextButton.setTitleColor(AppColor.whiteColor, for: .normal)

        if isDone {
            self.otpText = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTF.text ?? "")\(self.forthTF.text ?? "")"
            nextButton.setTitleColor(AppColor.whiteColor, for: .normal)

        }
    }
}

