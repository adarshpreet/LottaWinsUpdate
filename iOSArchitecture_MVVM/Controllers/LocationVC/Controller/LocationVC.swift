//
//  LocationVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 06/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class LocationVC: BaseViewController {
    
    @IBOutlet weak var btnBck: UIView!
    lazy var viewModel: LocationModel = {
         let obj = LocationModel(userService: UserService())
         self.baseVwModel = obj
         return obj
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // Call the roundCorners() func right there.
        btnBck.roundCorners(corners: [.topLeft, .topRight], radius: 40)
    }
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func btnEnableLocationAction(_ sender: Any) {
        AppUser.shared.setupLocationManagerServices()
        AppUser.shared.onMessage = { [weak self] token in
            guard let self = `self` else { return }
            if self.viewModel.isLocation {
                return
            }
            self.viewModel.isLocation = true
            self.viewModel.enableLocation()
        }
        AppUser.shared.onError = { [weak self] error in
            guard let _ = `self` else { return }
            if let errorObject = error as? Error {
                print("Some error - \(errorObject.localizedDescription)")
            }
        }
        
    }
    @IBAction func btnSkipAction(_ sender: Any) {
//    self.viewModel.enableNotification(isenableNotification: false, isSkipped: true)
                 Helper.shared.rootViewAfterSession()

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

extension LocationVC : BaseDataSources {
    
    func setUpClosures() {
        self.viewModel.redirectControllerClosure = { [weak self] in
            guard let _ = `self` else { return }
            DispatchQueue.main.async {
                Helper.shared.rootViewAfterSession()
            }
        }
    }
    
    func setUpView() {
        self.setUpClosures()
    }
}
