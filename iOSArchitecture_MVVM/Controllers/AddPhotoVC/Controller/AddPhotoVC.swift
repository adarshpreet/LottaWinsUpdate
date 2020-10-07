//
//  AddPhotoVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 05/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import TOCropViewController

class AddPhotoVC: BaseViewController, BaseDataSources {
    
    @IBOutlet weak var viewFOrBck: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var imgProfilePic: CustomImageView!
    
    lazy var viewModel: AddPhotoModel = {
        let obj = AddPhotoModel(userService: UserService())
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
          viewFOrBck.roundCorners(corners: [.topLeft, .topRight], radius: 40)
      }
    func setUpClosures() {
        self.viewModel.redirectControllerClosure = { [weak self] in
          guard let self = `self` else { return }
          DispatchQueue.main.async {
              self.performSegue(withIdentifier: Segues.dobSegue, sender: self)
          }
        }
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    func setUpView() {
//        self.btnContinue.isHidden = true
        btnContinue.setTitleColor(AppColor.grayNewColor, for: .normal)
        self.setUpClosures()
    }
  
    //MARK:- Tap on Actions
    @IBAction func btnSkipClick(_ sender: Any) {
      self.viewModel.uploadProfilePic(profileImage: nil, isSkipped: true)
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: Segues.dobSegue, sender: self)
//        }
    }
    
    @IBAction func btnChoosePhotoClick(_ sender: Any) {
        self.getPhotoFromLibraryAndCamera()
    }
    
    @IBAction func btnContinueClick(_ sender: Any) {
        if let image = self.imgProfilePic.image {
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: Segues.dobSegue, sender: self)
//            }

            self.viewModel.uploadProfilePic(profileImage: image, isSkipped: false)
        }
        
    }
    
    // MARK:- Gallery Actions
    private func getPhotoFromLibraryAndCamera() {
        
        let alert = UIAlertController(title: ConstantKeys.appName, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: ConstantKeys.camera, style: .default, handler: {(action: UIAlertAction) in
            self.cameraAccess(completionHandler: { (isGranted) in
                DispatchQueue.main.async(execute: {

                    if isGranted {
                        // Access allowed
                        self.getImage(fromSourceType: .camera)
                    } else {
                        let configAlert: AlertUI = (AlertMessage.noCameraAccess, AlertMessage.noCamera)
                        UIAlertController.showAlert(configAlert)
                    }
                })
            })
        }))
        alert.addAction(UIAlertAction(title: ConstantKeys.photo, style: .default, handler: {(action: UIAlertAction) in
            self.checkPhotoLibraryPermission(completionHandler: { (isGranted) in
                DispatchQueue.main.async(execute: {
                    if isGranted {
                        // Access allowed
                        self.getImage(fromSourceType: .photoLibrary)
                    } else {
                        let configAlert: AlertUI = (AlertMessage.noGalleryAccess, AlertMessage.noPhoto)
                        UIAlertController.showAlert(configAlert)
                    }
                })
            })
        }))
        alert.addAction(UIAlertAction(title: ConstantKeys.cancel, style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddPhotoVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
           
       //Check is source type available
       if UIImagePickerController.isSourceTypeAvailable(sourceType) {
           
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = sourceType
           self.present(imagePickerController, animated: true, completion: nil)
       }
    }
       
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
       
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let image = info[.originalImage] as? UIImage {
        
           let cropController = TOCropViewController(croppingStyle: .circular, image: image)
           cropController.delegate = self
           cropController.title = "Crop Image"
           let navigation = UINavigationController(rootViewController: cropController)

           picker.dismiss(animated: true, completion: {
               self.present(navigation, animated: true, completion: nil)
           })
       }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        self.updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        if cancelled {
            self.dismiss(animated: true, completion: nil)
        }
    }
       
    func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: TOCropViewController) {
        dismiss(animated: true, completion: nil)

        DispatchQueue.main.async {
            self.imgProfilePic.image = image
//            self.btnContinue.isHidden = false
            self.btnContinue.setTitleColor(AppColor.whiteColor, for: .normal)

        }
    }
}

