//
//  CountDownGiveAwayVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/8/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class CountDownGiveAwayVC: BaseViewController {
    
    @IBOutlet weak var joinCountLabel: UILabel!
    @IBOutlet weak var backgrounImage: UIImageView!
    @IBOutlet weak var poweredByLogo: UIImageView!
    @IBOutlet weak var timmerLabel: UILabel!
    
    var maximumValue = 300
    var countDownTimer: Timer?
    
    lazy var viewModel: CountDownGiveAwayVM = {
        let obj = CountDownGiveAwayVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()

    // MARK:- View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    // MARK:- Actions
    @IBAction func tapOnDismiss(_ sender: Any) {
        self.stopTimer()
        self.dismiss(animated: true, completion: nil)
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

extension CountDownGiveAwayVC: BaseDataSources {
    
    func setUpClosures() {
        
    }
    
    func setUpView() {
        self.setUpClosures()
        self.startCountDown()
        self.viewModel.fetchGiveAwayInformation()
    }
    
    func startCountDown() {
        self.countDownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            
            if timer.isValid {
                self.timmerLabel.text = self.timeString(time: TimeInterval(self.maximumValue))
                self.maximumValue -= 1
            }
        }
    }
    
    func stopTimer() {
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i", minutes, seconds)
    }
    
}
