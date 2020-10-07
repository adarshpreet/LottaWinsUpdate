//
//  ProfilePic.swift
//  iOSArchitecture_MVVM
//
//  Created by Gurpreet Singh on 02/10/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit

class ProfilePic: UIView {
    @IBOutlet weak var buttonTakePhoto: CustomButton!
//    @IBOutlet weak var cameraRollButton: CustomButton!
//    @IBOutlet weak var removeExitingPhoto: CustomButton!
//    @IBOutlet weak var cancelBtn: CustomButton!

    
    @IBOutlet weak var cancelBtn: CustomButton!
    @IBOutlet weak var removeExtingBtn: CustomButton!
    @IBOutlet weak var cameraRollBtn: CustomButton!
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
    }
}
