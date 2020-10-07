//
//  NotificationVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 06/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController {
    
    @IBOutlet weak var viewBack: UIView!
    lazy var viewModel: NotificationModel = {
      let obj = NotificationModel(userService: UserService())
      self.baseVwModel = obj
      return obj
    }()
    
    var deviceToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Call the roundCorners() func right there.
        viewBack.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    @IBAction func btnEnableNotificationAction(_ sender: Any) {
        AppUser.shared.registerForPushNotifications()
        AppUser.shared.onMessage = { [weak self] token in
            guard let self = `self` else { return }
            if let deviceToken = token as? String {
                self.deviceToken = deviceToken
                self.viewModel.enableNotification(isenableNotification: true)
            }
        }
        AppUser.shared.onError = { [weak self] error in
            guard let _ = `self` else { return }
            if let errorObject = error as? Error {
                print(errorObject.localizedDescription)
            }
        }
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnSkipAction(_ sender: Any) {
        self.viewModel.enableNotification(isenableNotification: false, isSkipped: true)
    }
    
    func navigateLocationVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: LocationVC.className) as! LocationVC
        self.navigationController?.show(vc, sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NotificationVC : BaseDataSources {
    
    func setUpClosures() {
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let self = `self` else { return }
            DispatchQueue.main.async {
                self.navigateLocationVC()
            }
        }
    }
    
    func setUpView() {
        self.setUpClosures()
    }
}
