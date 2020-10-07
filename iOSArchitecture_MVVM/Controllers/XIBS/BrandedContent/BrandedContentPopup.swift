//
//  BrandedContentPopup.swift
//  iOSArchitecture_MVVM
//
//  Created by Tarun on 22/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class BrandedContentPopup: UIViewController {

    @IBOutlet weak var closeBtn: UIButton?
    var time = 6

    override func viewDidLoad() {
        super.viewDidLoad()

        self.closeBtn?.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.time = self.time - 1
            print("Number: \(timer.timeInterval)")
            self.closeBtn?.setTitle("", for: .normal)
            self.closeBtn?.setTitle("\(self.time)", for: .normal)
            if self.time == 0 {
                timer.invalidate()
                self.closeBtn?.setTitle("X", for: .normal)
                self.closeBtn?.isEnabled = true
            }
        }
    }
    
    @IBAction func closeAdView(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            // Increase coins
        }
    }
}

