//
//  HomeVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/14/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class HomeVC: BaseViewController {
    
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        AppUser.defaults.set(true, forKey: DefaultKeys.openFirstTime)
    }
    
    @IBAction func tapOnLogout(_ sender: Any) {
        
        Helper.shared.destroySession()
        SwiftSockets.shared.disconnectSocket()
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

extension HomeVC: BaseDataSources {
    func setUpClosures() {
        
    }
    
    func setUpView() {
        guard let userInfor = UserSession.userInfo else { return }
        self.emailLabel.text = "Hello \(userInfor.email ?? "")"
    }
}
