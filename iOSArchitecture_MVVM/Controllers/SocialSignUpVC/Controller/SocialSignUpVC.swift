//
//  SocialSignUpVC.swift
//  iOSArchitecture_MVVM
//
//  Created by MyMac on 05/05/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import SCSDKLoginKit

class SocialSignUpVC: BaseViewController {
    
    @IBOutlet weak var lblGetStarted: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblApple: UILabel!
    @IBOutlet weak var lblSnapchat: UILabel!
    @IBOutlet weak var lblSMS: UILabel!
    @IBOutlet weak var containerView: EditingView!
    @IBOutlet weak var viewGoogle: EditingView!
    @IBOutlet weak var viewApple: EditingView!
    @IBOutlet weak var viewSnapchat: EditingView!
    @IBOutlet weak var viewSMS: EditingView!
    @IBOutlet weak var lastLoggedIn: UILabel!

    var isForLogin: Bool = false
    
    lazy var viewModel: SocailSignUpVM = {
        let obj = SocailSignUpVM(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreenUI()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func setShadowOf(_ view: EditingView) {
        view.shadowOpacity = 7
        view.shadowRadius = 10
        view.shadowOffset = CGPoint(x: 3, y: 3)
    }
    
    func clearShadowOf(_ view: EditingView) {
        view.shadowOpacity = 0
        view.shadowRadius = 0
        view.shadowOffset = CGPoint(x: 0, y: 0)
    }
    
    func getLastLogin(_ string: String) {
        
        let lastLogin = LoginKeys(rawValue: string) ?? .Apple
        
        switch lastLogin {
        case .Google:
            self.setShadowOf(self.viewGoogle)
        case .Apple:
            self.setShadowOf(self.viewApple)
        case .Snapchat:
            self.setShadowOf(self.viewSnapchat)
        default:
            self.setShadowOf(self.viewSMS)
        }
        
    }
    
    func setupScreenUI() {
                
        if let lastLogin = AppUser.defaults.value(forKey: DefaultKeys.lastLoginOption) as? String, lastLogin.count > 0, self.isForLogin {
            let formattedText = String.format(strings: [LoginKeys.Apple.rawValue, LoginKeys.Google.rawValue, LoginKeys.Snapchat.rawValue, LoginKeys.Username.rawValue],
                                              boldFont: AppFont.MuseoSansCyrl_900(fontSize: 15),
                                              boldColor: UIColor.white,
                                              inString: "You last logged in with \(lastLogin)",
                                              font: AppFont.MuseoSansCyrl_500(fontSize: 14),
                                              color: UIColor.white)
            self.lastLoggedIn.attributedText = formattedText
            self.getLastLogin(lastLogin)
        } else {
            self.clearShadowOf(self.viewSnapchat)
            self.clearShadowOf(self.viewGoogle)
            self.clearShadowOf(self.viewApple)
            self.clearShadowOf(self.viewSMS)
        }
        
        let boldFont = UIFont(name: AppFont.MuseoSansCyrl_900, size: 15.0)!
        let normalFont = UIFont(name: AppFont.MuseoSansCyrl_700, size: 15.0)!
        let boldFontAttribute = [NSAttributedString.Key.font : boldFont]
        let normalFontAttribute = [NSAttributedString.Key.font : normalFont]
        
        var strWith: String!
        if (self.isForLogin) {
            strWith = "Login with"
        } else {
            strWith = "Continue with"
        }
        
        let nsStringGoogle = "\(strWith ?? "") Google" as NSString
        let googleString = NSMutableAttributedString(string: nsStringGoogle as String)
        googleString.addAttributes(boldFontAttribute, range: nsStringGoogle.range(of: "Google"))
        googleString.addAttributes(normalFontAttribute, range: nsStringGoogle.range(of: strWith))
        self.lblGoogle.attributedText = googleString
        
        let nsStringApple = "\(strWith ?? "") Apple" as NSString
        let appleString = NSMutableAttributedString(string: nsStringApple as String)
        appleString.addAttributes(boldFontAttribute, range: nsStringApple.range(of: "Apple"))
        appleString.addAttributes(normalFontAttribute, range: nsStringApple.range(of: strWith))
        self.lblApple.attributedText = appleString
        
        let nsStringSnapchat = "\(strWith ?? "") Snapchat" as NSString
        let snapchatString = NSMutableAttributedString(string: nsStringSnapchat as String)
        snapchatString.addAttributes(boldFontAttribute, range: nsStringSnapchat.range(of: "Snapchat"))
        snapchatString.addAttributes(normalFontAttribute, range: nsStringSnapchat.range(of: strWith))
        self.lblSnapchat.attributedText = snapchatString
                        
        var nsStringSMS = "\(strWith ?? "") SMS" as NSString
        let smsString = NSMutableAttributedString(string: nsStringSMS as String)
        smsString.addAttributes(boldFontAttribute, range: nsStringSMS.range(of: "SMS"))
        smsString.addAttributes(normalFontAttribute, range: nsStringSMS.range(of: strWith))
        self.lblSMS.attributedText = smsString
        
        if (self.isForLogin) {
            nsStringSMS = "\(strWith ?? "") Username" as NSString
            let smsString = NSMutableAttributedString(string: nsStringSMS as String)
            smsString.addAttributes(boldFontAttribute, range: nsStringSMS.range(of: "Username"))
            smsString.addAttributes(normalFontAttribute, range: nsStringSMS.range(of: strWith))
            self.lblSMS.attributedText = smsString
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        let attrInfoString = NSMutableAttributedString(string: self.isForLogin ? "Login now to keep getting tickets for the hottest sweepstakes!": "Get started by logging in or creating an account to start winning.")
        attrInfoString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrInfoString.length))
        attrInfoString.addAttributes(normalFontAttribute, range: NSMakeRange(0, attrInfoString.length))
        self.lblInfo.attributedText = attrInfoString
        
        self.lblGetStarted.text = self.isForLogin ? "Continue Winning" : "Get Started"
    }
    
    // MARK:- Snapchat Fetch Info
    func fetchSnapUserInfo() {
        let graphQLQuery = "{me{displayName, bitmoji{avatar}, externalId}}"
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: nil, success: { (resources: [AnyHashable: Any]?) in
            DispatchQueue.main.async {
                guard let resources = resources,
                    let data = resources["data"] as? [String: Any],
                    let me = data["me"] as? [String: Any] else {
                        let configAlert: AlertUI = ("", "Error in login")
                        UIAlertController.showAlert(configAlert)
                        return
                }
                let externalId = me["externalId"] as? String
                let display_name = me["displayName"] as? String
                    
                var bitmojiURL = ""
                if let bitmoji = me[DefaultKeys.Bitmoji] as? KeyValue, bitmoji["avatar"] != nil {
                    bitmojiURL = bitmoji["avatar"] as? String ?? ""
                }
                
                let dict = [DefaultKeys.SocialProvider: LoginKeys.Snapchat.rawValue,
                            DefaultKeys.SocialID: externalId ?? "",
                            DefaultKeys.Email: "",
                            DefaultKeys.Firstname: display_name ?? "",
                            DefaultKeys.Lastname: "",
                            DefaultKeys.Bitmoji: bitmojiURL] as KeyValue
                
                self.checkLoginStatus(social_provider: LoginKeys.Snapchat.rawValue, social_id: externalId ?? "") { (isSuccess, message) in
                    
                    if isSuccess {
                        self.checkEmailVerification(.Snapchat)
                    } else {
                        if self.isForLogin {
                            let configAlert: AlertUI = ("", message)
                            UIAlertController.showAlert(configAlert)
                        } else {
                            self.navigateToEmailVC(dict: dict as KeyValue)
                        }
                    }
                }
            }
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
            DispatchQueue.main.async {
                let configAlert: AlertUI = ("", error?.localizedDescription ?? "Some Error occured")
                UIAlertController.showAlert(configAlert)
            }
        })
    }
    
    private func navigateToEmailVC(dict: KeyValue) {
        let enterEmailVC = self.storyboard?.instantiateViewController(withIdentifier: EnterEmailVC.className) as! EnterEmailVC
        enterEmailVC.UserInfoDict = dict
        self.navigationController?.show(enterEmailVC, sender: self)
    }
    
    // MARK:- IBActions
    @IBAction func btnCloseClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGoogleClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnAppleClick(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    @IBAction func btnSnapchatClick(_ sender: Any) {
        SCSDKLoginClient.login(from: self, completion: { success, error in
            if let error = error {
                DispatchQueue.main.async {
                    let configAlert: AlertUI = ("", error.localizedDescription)
                    UIAlertController.showAlert(configAlert)
                }
                return
            }
            if success {
                self.fetchSnapUserInfo()
            }
        })
    }
    
    @IBAction func btnSMSClick(_ sender: Any) {
        if self.isForLogin {
            if let vc = self.mainStoryboardController(withIdentifier: LoginUsernameVC.className) as? LoginUsernameVC {
                vc.handler = { [weak self] onMessage in
                    guard let self = `self` else { return }
                    
                    if let isChange = onMessage as? Bool {
                        self.isForLogin = isChange
                        self.setupScreenUI()
                    }
                }
                self.navigationController?.show(vc, sender: self)
            }
        } else {
            if let vc = self.mainStoryboardController(withIdentifier: PhoneSignupVC.className) as? PhoneSignupVC {
                self.navigationController?.show(vc, sender: self)
            }
        }
    }

}

extension SocialSignUpVC: ASAuthorizationControllerPresentationContextProviding {
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension SocialSignUpVC: ASAuthorizationControllerDelegate {
    // Authorization Failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        let configAlert: AlertUI = ("", error.localizedDescription)
//        UIAlertController.showAlert(configAlert)
    }
    // Authorization Succeeded
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Get user data with Apple ID credentitial
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email

            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        switch credentialState {
                        case .authorized:
                            
                            let dict = [DefaultKeys.SocialProvider: LoginKeys.Apple.rawValue,
                                        DefaultKeys.SocialID: userIdentifier,
                                        DefaultKeys.Email: userEmail,
                                        DefaultKeys.Firstname: userFirstName ?? "",
                                        DefaultKeys.Lastname: userLastName ?? ""]
                            
                            
                            self.checkLoginStatus(social_provider: LoginKeys.Apple.rawValue, social_id: userIdentifier, emailId: userEmail ?? "") { (isSuccess, message) in
                                if isSuccess {
                                    self.checkEmailVerification(.Apple)
                                } else {
                                    
                                    if self.isForLogin {
                                        let configAlert: AlertUI = ("", message)
                                        UIAlertController.showAlert(configAlert)
                                    } else {
                                        if userEmail == nil {
                                            self.navigateToEmailVC(dict: dict as KeyValue)
                                        } else {
                                            self.viewModel.socialSignup(social_provider: LoginKeys.Apple.rawValue, social_id: userIdentifier, email: userEmail ?? "") { (isSuccess, message) in
                                                if isSuccess {
                                                    self.checkEmailVerification(.Apple)
                                                } else {
                                                    let configAlert: AlertUI = ("", message)
                                                    UIAlertController.showAlert(configAlert)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        case .revoked:
                            let configAlert: AlertUI = ("", "Your credential is revoked.")
                            UIAlertController.showAlert(configAlert)
                        case .notFound:
                            let configAlert: AlertUI = ("", "Your credential not found.")
                            UIAlertController.showAlert(configAlert)
                        default:
                            break
                        }
                    } else {
                        let configAlert: AlertUI = ("", error?.localizedDescription ?? "Some Error occured")
                        UIAlertController.showAlert(configAlert)
                    }
                }
            }
        }
    }
}

extension SocialSignUpVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        DispatchQueue.main.async {
            if let googleError = error {
                if googleError.localizedDescription == "The user canceled the sign-in flow." {
                    return
                }
                
                let configAlert: AlertUI = ("", error.localizedDescription)
                UIAlertController.showAlert(configAlert)
                return
            }
            
            // Perform any operations on signed in user here.
            let userId = user.userID ?? ""
            let email = user.profile.email ?? ""
            
            self.checkLoginStatus(social_provider: LoginKeys.Google.rawValue, social_id: userId, emailId:email) { (isSuccess, message) in
                if isSuccess {
                    self.checkEmailVerification(.Google)
               } else {
                    
                    if self.isForLogin {
                        let configAlert: AlertUI = ("", message)
                        UIAlertController.showAlert(configAlert)
                    } else {
                        self.viewModel.socialSignup(social_provider: LoginKeys.Google.rawValue, social_id: userId, email: email) { (isSuccess, message) in
                            if isSuccess {
                                self.checkEmailVerification(.Google)
                            } else {
                                let configAlert: AlertUI = ("", message)
                                UIAlertController.showAlert(configAlert)
                            }
                        }
                    }
               }
            }
        }
    }
    
    
    func checkEmailVerification(_ lastLogin: LoginKeys) {
        
        Helper.shared.lastLogin(lastLogin)
        guard let userSess = self.viewModel.userModel else { return }

        if let isVerifiedEmail = userSess.is_verified, isVerifiedEmail {

            DispatchQueue.main.async {
                Helper.shared.rootViewAfterSession()
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.verifyEmailSegue, sender: self)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        dismiss(animated: true) {() -> Void in }
    }
    
    
    func checkLoginStatus(social_provider: String, social_id: String, emailId: String = "", completion: @escaping ResponseBlock) {
        
        self.viewModel.socialLogin(social_provider: social_provider, social_id: social_id, emailId: emailId) { (isSuccess, message) in
            completion(isSuccess, message)
       }
    }
}
