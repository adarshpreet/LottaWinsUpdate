//
//  ForgotPasswordVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/12/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class ForgotPasswordVC: BaseViewController {
    
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    lazy var viewModel: ForgotPasswordVM = {
       let obj = ForgotPasswordVM(userService: UserService())
       self.baseVwModel = obj
       return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }

    
    // MARK:- Actions
    @IBAction func tapOnReset(_ sender: Any) {
        self.viewModel.validations(self.emailTF.text)
    }
    
    // MARK:- Actions
    @IBAction func tapOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destination = segue.destination as? TempPasswordVC else { return }
        destination.viewModel.userEmail = self.emailTF.text
    }
    

}

extension ForgotPasswordVC: BaseDataSources {
    
    func setUpView() {
        self.setUpClosures()
    }
    
    func setUpClosures() {
        
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                self.emailTF.clearBorderColor()
                self.erroViewDisplay(true, message: "")
                self.performSegue(withIdentifier: Segues.verifyTempPassword, sender: self)
            }
        }
        
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
          guard let self = `self` else { return }
          let message = serverMessage ?? ""
          DispatchQueue.main.async {
              self.emailTF.hightLighttextField()
              self.erroViewDisplay(false, message: message)
          }
       }
        
        self.viewModel.updateUI = { [weak self] errortype in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
//                switch errortype {
//                case .email:
//                     self.emailTF.hightLighttextField()
//                     
//                    let count = (self.emailTF.text ?? "").count
//                    self.erroViewDisplay(false, message: count == 0 ? AlertMessage.emptyEmail : AlertMessage.invalidEmail)
//                     self.emailTF.becomeFirstResponder()
//                    break
//                  default:break
//                }
            }
        }
    }
    
    func erroViewDisplay(_ isShow: Bool, message: String) {
        self.errorView.isHidden = isShow
        self.errorLabel.text = message
    }
    
}
