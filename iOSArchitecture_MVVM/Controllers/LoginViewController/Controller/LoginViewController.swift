//
//  LoginViewController.swift
//  EmployeeHealth
//
//  Created by Surjeet Singh on 14/03/2019.
//  Copyright © 2019 Surjeet Singh. All rights reserved.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import SCSDKLoginKit

class LoginViewController: BaseViewController {
    // MARK: Outlets
    @IBOutlet weak var loginWithSnapchatButton: UIButton!
    @IBOutlet weak var loginWithAppleButton: UIButton!
    @IBOutlet weak var loginWithGoogleButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Variables
    lazy var viewModel: LoginViewModel = {
        let obj = LoginViewModel(userService: UserService())
        self.baseVwModel = obj
        return obj
    }()
    private struct TextFieldTags {
        static let emailTextField = 100
        static let passwordTextField = 101
    }
    var isLoginEnabled: Bool {
        get {
            return loginButton.isUserInteractionEnabled
        }
        set {
            if newValue {
                loginButton.isUserInteractionEnabled = true
                loginButton.backgroundColor = UIColor.red
            } else {
                loginButton.isUserInteractionEnabled = false
                loginButton.backgroundColor = UIColor.lightGray
            }
        }
    }
    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoginEnabled = false
        setupClosures()
        self.setUpColors()
        self.setUpUI()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    // MARK: Setup
    func setupClosures() {
        viewModel.redirectControllerClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.navigateToHomeScreen()
            }
        }
    }
    /// This method would change the color according to your mode. if you have light mode then the background color will be white or vice-versa.
    func setUpColors() {
        self.view.backgroundColor = ColorCompatibility.myOlderiOSCompatibleColorName
    }
    func setUpUI() {
        loginWithAppleButton.layer.cornerRadius = loginWithAppleButton.bounds.size.height / 2
        loginWithAppleButton.layer.masksToBounds = true
        loginWithGoogleButton.layer.cornerRadius = loginWithAppleButton.bounds.size.height / 2
        loginWithGoogleButton.layer.masksToBounds = true
        loginWithSnapchatButton.layer.cornerRadius = loginWithSnapchatButton.bounds.size.height / 2
        loginWithSnapchatButton.layer.masksToBounds = true
    }
    func navigateToHomeScreen() {
        //        let coontroller = self.storyboard?.instantiateViewController(withIdentifier: HomeViewController.className) as! HomeViewController
        //        self.navigationController?.pushViewController(coontroller, animated: true)
    }
    // MARK: Button Actions
    @IBAction func onLoginClick(_ sender: UIButton) {
        viewModel.login(withEmail: emailTextField.text, password: passwordTextField.text)
    }
    @IBAction func onLoginWithGoogleClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func onLoginWithAppleClick(_ sender: Any) {
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
    
    @IBAction func onLoginWithSnapchatClick(_ sender: Any) {
        SCSDKLoginClient.login(from: self, completion: { success, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            if success {
                self.fetchSnapUserInfo()
            }
        })
    }
    
    func fetchSnapUserInfo() {
        let graphQLQuery = "{me{displayName, bitmoji{avatar}, externalId}}"
        
        SCSDKLoginClient.fetchUserData(withQuery: graphQLQuery, variables: nil, success: { (resources: [AnyHashable: Any]?) in
          guard let resources = resources,
            let data = resources["data"] as? [String: Any],
            let me = data["me"] as? [String: Any] else { return }
            let externalId = me["externalId"] as? String
            
            print(data)
            print(externalId ?? "")
            
        }, failure: { (error: Error?, isUserLoggedOut: Bool) in
            // handle error
            print(error?.localizedDescription ?? "")
        })
    }
    
}

// MARK: TextField Delegate Methods

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var email = emailTextField.text, var password = passwordTextField.text else { return true }
        switch textField.tag {
        case TextFieldTags.emailTextField:
            if string == "" {
                email.removeLast()
            } else {
                email.append(string)
            }
        case TextFieldTags.passwordTextField:
            if string == "" {
                password.removeLast()
            } else {
                password.append(string)
            }
        default:
            break
        }
        let validity = viewModel.isValid(email: email, password: password)
        isLoginEnabled = validity.isValid
        return true
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    // For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    // Authorization Failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let configAlert: AlertUI = ("", error.localizedDescription)
        UIAlertController.showAlert(configAlert)
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
            print("User ID: \(userIdentifier)")
            print("User First Name: \(userFirstName ?? "")")
            print("User Last Name: \(userLastName ?? "")")
            print("User Email: \(userEmail ?? "")")
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
                DispatchQueue.main.async {
                    if error == nil {
                        switch credentialState {
                        case .authorized:
                            let configAlert: AlertUI = ("", "Successfully logged in!")
                            UIAlertController.showAlert(configAlert)
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
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Get user data using an existing iCloud Keychain credential
            let appleUsername = passwordCredential.user
            let applePassword = passwordCredential.password
            // Write your code here
        }
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        DispatchQueue.main.async {
            if let error = error {
                let configAlert: AlertUI = ("", error.localizedDescription)
                UIAlertController.showAlert(configAlert)
                return
            }
            // Perform any operations on signed in user here.
            let userId = user.userID ?? ""                  // For client-side use only!
            let idToken = user.authentication.idToken ?? "" // Safe to send to the server
            let fullName = user.profile.name ?? ""
            let givenName = user.profile.givenName ?? ""
            let familyName = user.profile.familyName ?? ""
            let email = user.profile.email ?? ""
            print("userId : \(userId), idToken: \(idToken), fullName:\(fullName), givenName: \(givenName), familyName: \(familyName), email:\(email)")
            let configAlert: AlertUI = ("", "Successfully logged in!")
            UIAlertController.showAlert(configAlert)
        }
    }
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
        // Close OAuth2 authentication window
        dismiss(animated: true) {() -> Void in }
    }
}
