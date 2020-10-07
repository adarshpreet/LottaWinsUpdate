//
//  LotteryChatVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 6/4/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import MMPlayerView

class LotteryChatVC: BaseViewController {
    
    @IBOutlet weak var joinCountLabel: UILabel!
    @IBOutlet weak var backgrounImage: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var pinnedMsgLabel: UILabel!
    @IBOutlet weak var pinnedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pinnedStaticLabel: UILabel!
    @IBOutlet weak var pinnedMsgImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: CustomButton!
    @IBOutlet weak var textView: CustomTextView!
    @IBOutlet weak var videoSoundButton: UIButton!
    @IBOutlet weak var enterGiveAway: CustomButton!
    
    var videoPlayer : MMPlayerLayer?
    var refreshControl: UIRefreshControl!
    
    lazy var viewModel: LotteryChatVM = {
        let obj = LotteryChatVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    var lastIndexPath : IndexPath {
        let insertedRow = self.viewModel.listMessages.count > 0 ? self.viewModel.listMessages.count - 1 : 0
        return IndexPath(row: insertedRow, section: 0)
    }
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.enableKeyboard(isEnable: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.enableKeyboard(isEnable: true)
    }
    
    private func enableKeyboard(isEnable:Bool) {
        IQKeyboardManager.shared.enableAutoToolbar = isEnable
        IQKeyboardManager.shared.enable = isEnable
    }
    
    func setupCell(_ model: GiveAwayListBase?) {
        guard let data = model else { return }
        self.backgrounImage?.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let coverImage = data.cover_image else { return }
        let mediaURL = coverImage.image ?? ""
        self.videoSoundButton.isHidden = mediaURL.isImage()
        let type = data.type ?? ""
        self.enterGiveAway.setTitle("Enter \(type)", for: .normal)
        
        self.backgrounImage?.layer.cornerRadius = 25
        self.backgrounImage?.clipsToBounds = true
        self.pinnedMsgLabel.text = data.pinned_message
        // self.pinnedViewHeight.constant = (data.pinned_message ?? "").count > 0 ? 90 : 0
        
        self.backgrounImage?.sd_setImage(with: URL(string: data.cover_image?.image ?? ""), placeholderImage: UIImage(named: "group18"), options: .continueInBackground, context: nil)
        self.logoImageView?.sd_setImage(with: URL(string: data.client?.company_logo ?? ""), placeholderImage: UIImage(named: "Placeholderimage"), options: .continueInBackground, context: nil)
        self.joinCountLabel.text = "\(data.user_count ?? 0)"
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func tapOnEnterNow(_ sender: Any) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            if let parent = self.parent as? TabBarVC {
                parent.showGiveAwayTab(true)
                SwiftSockets.shared.disconnectSocket()
            }
        }
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        
        let trimmedStringPostString = ((textView.text) as NSString).trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        self.textView.text = trimmedStringPostString
        
        if textView.text.count == 0 {
            let configAlert : AlertUI = ("", "Please enter some text.")
            UIAlertController.showAlert(configAlert)
        } else {
            
            self.viewModel.sendMessage(text: self.textView.text)
            self.textView.text = ""
            self.chatContainerHeight.constant = 50
        }
    }
    
    
    @IBAction func tapOnCrossBtn(_ sender: Any) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            if let parent = self.parent as? TabBarVC {
                parent.showGiveAwayTab()
                SwiftSockets.shared.disconnectSocket()
            }
        }
    }
}

extension LotteryChatVC : BaseDataSources {
    
    func setUpClosures() {
        self.viewModel.redirectClosure = { [weak self] type in
            guard let self = `self` else { return }
            if type == "didLoad" {
                self.viewModel.listMessages.removeAll()
                self.playHorizontalCoverVideos()
                self.internalDidLoad()
                //                self.viewModel.initializeWebSocket()
                self.tableView.reloadData()
                // First time automatically refreshing.
                self.refreshControl.beginRefreshingManually()
                self.perform(#selector(self.getSavedChat), with: nil, afterDelay: 0)
            } else if type == "socketConnected" {
                // When socket connected or disconnected this block would get executed.
                print("Socket is \(SwiftSockets.shared.isConnected == true ? "Connected" : "Disconnected")")
                self.sendBtn.isEnabled = SwiftSockets.shared.isConnected
            } else if type == "newMessage" {
                // When ever current user send message or Any pther person send message this block would get executed
                if let newObject = self.viewModel.newMessage {
                    if self.viewModel.listMessages.count == 0 {
                        self.viewModel.listMessages = [newObject]
                        self.tableView.reloadData()
                    } else {
                        self.reloadLastMessage(model: newObject)
                    }
                }
            } else if type == "newLists" {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.scrollToBottom(animated: true)
            } else if type == "oldMessages" {
                self.refreshControl.endRefreshing()
                self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
                self.tableView.reloadData()
            } else if type == "errorResponse" {
                self.refreshControl.endRefreshing()
            }
        }
        self.viewModel.serverErrorMessages = { [weak self] serverMessage in
            guard let _ = `self` else { return }
            let message = serverMessage ?? ""
            DispatchQueue.main.async {
                let configAlert : AlertUI = ("", message)
                UIAlertController.showAlert(configAlert)
            }
        }
    }
    
    //MARK:- TableView Set To bottom
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.viewModel.listMessages.count > 0 {
                self.tableView.scrollToRow(at: self.lastIndexPath, at: .bottom, animated: animated)
            } // end if
        }
    }
    
    func internalDidLoad() {
        self.setupCell(self.viewModel.giveAwayDetail)
    }
    
    func setUpView() {
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.setUpClosures()
        self.addObserver()
//      self.textView.textColor = UIColor.blue
        self.tableView.registerNIB(ChatCell.className)
        self.addTapGesture()
        self.refreshControlAPI()
        
    }
    
    // MARK: - refresh control For API
    func refreshControlAPI() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = AppColor.greenColor
        self.refreshControl.addTarget(self, action: #selector(self.getSavedChat), for: .valueChanged)
        self.tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func getSavedChat() {
        if self.viewModel.chatoffset == 0 {
            self.viewModel.fetchChatLists()
        } else {
            if self.viewModel.listMessages.count >= 10 {
                let lastModel = self.viewModel.listMessages[0]
                self.viewModel.fetchChatLists(lastModel.createdAt)
            } else {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func addTapGesture() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        DispatchQueue.main.async {
            if let bottomCons = self.bottomContainerConstraint, bottomCons.constant == 72 {
                if let parent = self.parent as? TabBarVC {
                    parent.showGiveAwayTab()
                    SwiftSockets.shared.disconnectSocket()
                 //   self.textView.text = ""
                    self.chatContainerHeight.constant = 50
                    self.bottomContainerConstraint.constant = 72
                    self.viewModel.chatoffset = 0
                }
            } else {
                self.chatContainerHeight.constant = 50
                self.bottomContainerConstraint.constant = 72
                self.viewModel.chatoffset = 0
                self.view.endEditing(true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            if let bottomCons = self.bottomContainerConstraint, bottomCons.constant == 72 {
                if let parent = self.parent as? TabBarVC {
                    parent.showGiveAwayTab()
                    SwiftSockets.shared.disconnectSocket()
                 //   self.textView.text = ""
                    self.chatContainerHeight.constant = 50
                    self.bottomContainerConstraint.constant = 72
                    self.viewModel.chatoffset = 0
                }
            } else {
                //                if let parent = self.parent as? TabBarVC {
                //                parent.showGiveAwayTab()
                //                }
                self.chatContainerHeight.constant = 50
                self.bottomContainerConstraint.constant = 72
                self.viewModel.chatoffset = 0
                self.view.endEditing(true)
            }
        }
        
    }
}

extension LotteryChatVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.className, for: indexPath) as? ChatCell else { return UITableViewCell() }
        let model = self.viewModel.listMessages[indexPath.row]
        cell.avtarImage.layer.cornerRadius = cell.avtarImage.frame.height/2
        cell.avtarImage.clipsToBounds = true
        cell.avtarImage.sd_setImage(with: URL(string: model.avtarPic ?? ""), placeholderImage: UIImage(named: "Placeholderimage"), options: .continueInBackground, context: nil)
        cell.avtarMessage.text = model.avtarMessage
       
        cell.selectionStyle = .none
        return cell
    }
}

extension LotteryChatVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



