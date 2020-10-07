//
//  ProfileVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/22/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import SDWebImage
import TOCropViewController

class ProfileVC: BaseViewController {
    
    @IBOutlet weak var heightConstarintofTicket: NSLayoutConstraint!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var ticketCollection : UICollectionView!
    
    lazy var viewModel: ProfileVM = {
        let obj = ProfileVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    var usernameView: UserNameView?
    var profilepicView: ProfilePic?
    
    var screenSize: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
        // FlowLayout for ticket colection
        screenSize = UIScreen.main.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // let collectionWidth = self?.lotteryCollection?.frame.size.width ?? 0
        layout.itemSize = CGSize(width: self.screenSize?.width ?? 375 , height: 570)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        self.ticketCollection?.collectionViewLayout = layout
    }
    
    @objc func showEditUserName() {
        
        DispatchQueue.main.async {
            self.usernameView = UserNameView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.usernameView?.doneBtn.addTarget(self, action: #selector(self.tapOnSubmitButton), for: .touchUpInside)
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnDismiss))
            self.usernameView?.addGestureRecognizer(tap)
            guard let userInfo = UserSession.userInfo else { return  }
            self.usernameView?.userNameFillTF.text = self.isSocialLogin ? "NA" : userInfo.username ?? ""
            AppUser.shared.window?.addSubview(self.usernameView!)
        }
    }
    @objc func showProfilePic() {
        
        DispatchQueue.main.async {
            self.profilepicView = ProfilePic(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            self.profilepicView?.buttonTakePhoto.addTarget(self, action: #selector(self.tapOnTakePicButton), for: .touchUpInside)
            self.profilepicView?.cameraRollBtn.addTarget(self, action: #selector(self.tapOncameraRollButton), for: .touchUpInside)
            self.profilepicView?.removeExtingBtn.addTarget(self, action: #selector(self.tapOnremoveExitingPhoto), for: .touchUpInside)
            self.profilepicView?.cancelBtn.addTarget(self, action: #selector(self.tapOnCancelButton), for: .touchUpInside)
            AppUser.shared.window?.addSubview(self.profilepicView!)
        }
    }
    @objc func tapOnTakePicButton(_ sender: UIButton) {
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
    }
    @objc func tapOncameraRollButton(_ sender: UIButton) {
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
    }
    @objc func tapOnremoveExitingPhoto(_ sender: UIButton) {
        self.viewModel.uploadProfilePic(profileImage: nil, isSkipped: true)
    }
    @objc func tapOnCancelButton(_ sender: UIButton) {
        self.profilepicView?.removeFromSuperview()
    }
    
    @objc func tapOnSubmitButton(_ sender: UIButton) {
        guard let userView = self.usernameView else { return }
        let validation = self.viewModel.validateFields(userView.usernamTF.text)
        guard let isValid = validation.0, isValid else {
            userView.errorLabel.text = validation.1
            return
        }
        self.viewModel.updateUsername(userView.usernamTF.text ?? "") { (isSuccess, errorMsg) in
            if isSuccess {
                DispatchQueue.main.async {
                    userView.errorLabel.text = ""
                    userView.removeFromSuperview()
                    self.tableView.reloadData()
                }
            } else {
                userView.errorLabel.text = errorMsg
            }
        }
    }
    
    @objc func tapOnDismiss() {
        self.usernameView?.removeFromSuperview()
    }
    
    @objc func shareUsernameCode() {
        
        guard let userInfo = UserSession.userInfo else { return }
        let username = userInfo.username ?? ""
        
        let items = ["Play live lottery and win cash, exclusive prizes with me on. LottaWins, use my code \"\(username)\" to sign up!"]
        DispatchQueue.main.async {
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
        }
    }
    
    @objc func tapOnLogout() {
        
        //       let storyboard = UIStoryboard(name: Storyboards.home, bundle: nil)
        //        guard let quizVC = storyboard.instantiateViewController(withIdentifier: CountDownGiveAwayVC.className) as? CountDownGiveAwayVC else { return }
        //        self.present(quizVC, animated: true, completion: nil)
        
        let configAlert : AlertUI = ("", AlertMessage.signOut)
        UIAlertController.showAlert(configAlert, sender: nil, actions: AlertAction.Okk, AlertAction.cancel) { [weak self] (isItem) in
            guard let _ = `self` else { return }
            if isItem.title == AlertAction.Okk.title {
                Helper.shared.destroySession()
                SwiftSockets.shared.disconnectSocket()
            }
        }
    }
    
    func profileInternalDidLoad() {
        self.viewModel.fetchProfile()
        self.viewModel.fetchTickets()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func acnLogout(_ sender: UIButton){
        self.tapOnLogout()
    }
    
}

extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.ticketList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyTicketNoCell.className, for: indexPath) as? MyTicketNoCell else { return UICollectionViewCell() }
        guard let data = self.viewModel.ticketList?[indexPath.row] else { return UICollectionViewCell() }
        cell.dataSource = data
        cell.reloadList()
        return cell
    }
    
}

extension ProfileVC : UITableViewDataSource, UITableViewDelegate {
    
    var isSocialLogin: Bool {
        guard let userInfor = UserSession.userInfo else { return false }
        let name = userInfor.username ?? ""
        let email = userInfor.email ?? ""
        return name == email
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        case 1:
            return 60
        default:
            return 140
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 && section != 1 {
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "MyTicketHeaderCell") as? MyTicketHeaderCell else { return UIView() }
            headerCell.setupCell((self.viewModel.ticketList?[section - 2])!)
            return headerCell
        }
        if section == 1 {
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "TicketTitleHeaderCell") as? TicketTitleHeaderCell else { return UIView() }
            return headerCell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 + (self.viewModel.ticketList?.count ?? 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketsCell.className) as? MyTicketsCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.logoutBtn.addTarget(self, action: #selector(tapOnLogout), for: .touchUpInside)
            return cell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return section == 0 ? 3: 1
        if section == 0 {
            return 4
        } else if section == 1 {
            return 1
        }
        
        return self.viewModel.ticketList?[section - 2].code?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoUserNameCell.className, for: indexPath) as? PhotoUserNameCell else { return UITableViewCell()}
                guard let userInfo = UserSession.userInfo else { return cell }
                cell.avatarName.text = isSocialLogin ? "NA" : userInfo.username ?? ""
                cell.avatarImage?.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.avatarImage?.sd_setImage(with: URL(string: userInfo.profile_pic ?? ""), placeholderImage: nil)
                cell.avatarUsernameEdit.addTarget(self, action: #selector(showEditUserName), for: .touchUpInside)
                cell.avatarImgEdit.addTarget(self, action: #selector(showProfilePic), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyCoinsCell.className, for: indexPath) as? MyCoinsCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                guard let userInfo = UserSession.userInfo else { return cell }
                cell.coinsCountLabel.text = "\(userInfo.coins ?? 0)"
                let title = isSocialLogin ? "NA" : (userInfo.username ?? "")
                cell.shareCodeBtn.setTitle("\(title)", for: .normal)
                cell.shareCodeBtn.addTarget(self, action: #selector(shareUsernameCode), for: .touchUpInside)
                
//                cell.clipsToBounds = true
//                cell.layer.cornerRadius = 20
//                cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
                return cell
                
            case 2 :
                guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.className, for: indexPath) as? NotificationCell else { return UITableViewCell()}
                guard let userInfo = UserSession.userInfo else { return cell }
                cell.notificationSwitch.setOn(userInfo.enable_notification ?? false , animated: false)
                cell.selectionStyle = .none
                return cell

                default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyWinningsTableViewCell.className, for: indexPath) as? MyWinningsTableViewCell else { return UITableViewCell()}
                cell.selectionStyle = .none
                return cell
            }
        }
        else if indexPath.section == 1 {
            return UITableViewCell()
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketsNumberCell.className) as? MyTicketsNumberCell else { return UITableViewCell() }
            guard let dataModel = self.viewModel.ticketList?[indexPath.section - 2].code?[indexPath.row] else { return UITableViewCell() }
            let date = self.viewModel.ticketList?[indexPath.section - 2].start_date ?? ""
            cell.setupCell(dataModel, date)
            return cell
            
            
            /*guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTicketsCell.className, for: indexPath) as? MyTicketsCell else { return UITableViewCell()}
             cell.selectionStyle = .none
             cell.logoutBtn.addTarget(self, action: #selector(tapOnLogout), for: .touchUpInside)
             
             return cell */
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        switch indexPath.row {
        case 3:
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier:  "MyWinningsVC") as! MyWinningsVC
                self.navigationController?.pushViewController(vc, animated: false)

            } else {
                // Fallback on earlier versions
            }
            
        default:
            break
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 280
            case 1:
                return 270
            case 2:
                return 80
            default:
                return 60
            }
        } else {
            return 60
        }
    }
}

extension ProfileVC : BaseDataSources {
    
    func setUpClosures() {
        
        self.viewModel.validUIClosures = { [weak self] onMessage in
            guard let self = `self` else { return }
            if onMessage == "uploadImage" {
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            } else if onMessage == "updateNotification" {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: 1, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
        
        viewModel.reloadListViewClosure = { [weak self] () in
            guard let self = `self` else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if  self.viewModel.ticketList?.count  == 0{
                    self.heightConstarintofTicket.constant = 0
                }else{
                    self.heightConstarintofTicket.constant = 570

                }
                self.ticketCollection.reloadData()
            }
        }
        self.viewModel.redirectClosure = { [weak self] onMessage in
            guard let self = `self` else { return }
            if onMessage == "readProfile" {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setUpView() {
        self.setUpClosures()
        self.viewModel.fetchProfile()
        self.tableView.registerNIB(PhotoUserNameCell.className)
        self.tableView.registerNIB(NotificationCell.className)
        self.tableView.registerNIB(MyWinningsTableViewCell.className)
        self.tableView.registerNIB(MyCoinsCell.className)
        self.tableView.registerNIB(MyTicketsCell.className)
    }
}

extension ProfileVC {
    
    // MARK:- Gallery Actions
    @objc func getPhotoFromLibraryAndCamera() {
        
        let alert = UIAlertController(title: ConstantKeys.appName, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: ConstantKeys.cameraMsg, style: .default, handler: {(action: UIAlertAction) in
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
        alert.addAction(UIAlertAction(title: ConstantKeys.galleryMsg, style: .default, handler: {(action: UIAlertAction) in
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
        
        alert.addAction(UIAlertAction(title: ConstantKeys.existPhoto, style: .default, handler: {(action: UIAlertAction) in
            
            self.viewModel.uploadProfilePic(profileImage: nil, isSkipped: true)
            
        }))
        alert.addAction(UIAlertAction(title: ConstantKeys.cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ProfileVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
    
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
            let indexPath = IndexPath(row: 0, section: 0)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PhotoUserNameCell else { return }
            cell.avatarImage.image = image
            self.viewModel.uploadProfilePic(profileImage: image, isSkipped: false)
            self.profilepicView?.removeFromSuperview()
        }
    }
}
