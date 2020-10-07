//
//  WebViewVC.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/6/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import UIKit
import WebKit

enum WebPages {
    case privacyPolicy
    case termsCondition
    case faqs
    case none
}

class WebViewVC: BaseViewController {

    @IBOutlet weak var webviewTC: WKWebView!
    var currentWebPage = WebPages.none
    var indicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar(false, animated: true)

        self.setUpView()
        self.setWebViewContent()
    }
    
    @IBAction func tapOnCross(_ sender: Any) {
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
    
    func setWebViewContent() {
        
        guard let url = URL(string: Config.faq) else { return }
        let request = URLRequest(url: url)
        self.webviewTC.load(request)
    }

}

extension WebViewVC : BaseDataSources {
    
    func setUpClosures() {
        
    }
    
    func setUpView() {
        self.loadIndicator()
        
        switch currentWebPage {
        case .privacyPolicy:
            self.title = "Privacy Policy"
        case .termsCondition:
            self.title = "Terms & Condition"
        case .faqs:
            break
        default:
            break
        }
    }
    
    func loadIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        indicator?.tintColor = UIColor.white
        indicator?.color = UIColor.white

        let barButton = UIBarButtonItem(customView: indicator!)
        self.navigationItem.setLeftBarButton(barButton, animated: true)
        
        self.webviewTC.navigationDelegate = self
    }
    
}

extension WebViewVC : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator?.startAnimating()
        print("Start to load")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        indicator?.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator?.stopAnimating()
        print("finish to load")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        indicator?.startAnimating()
        print("redirection")
    }
}
