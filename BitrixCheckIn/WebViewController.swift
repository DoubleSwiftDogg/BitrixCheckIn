//
//  WebViewController.swift
//  BitrixCheckIn
//
//  Created by MacBook on 26.10.2018.
//  Copyright © 2018 PB. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var url: URL! = URL(string: "https://bitrix.belbeton.ru/local/zhbk1/apps/hmap/index.php")
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let savedLogin = "sysoevpb"
        let savedPassword = "5594262"
        
        let fillForm = String(format: "document.getElementsByName('USER_PASSWORD')[0].value = '\(savedPassword)';document.getElementsByName('USER_LOGIN')[0].value = '\(savedLogin)';")
        webView.evaluateJavaScript(fillForm, completionHandler: nil)
        //submit form
        //dispatch_after(dispatch_time(UInt64(DISPATCH_TIME_NOW), Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue()){
        webView.evaluateJavaScript("document.forms[\"form_auth\"].submit();")
    }
    
    
    /* func webViewDidFinishLoad(webView: UIWebView) {
        
        
        let savedPassword = "5594262"
        
        let fillForm = String(format: "document.getElementById('USER_PASSWORD').value = '\(savedPassword)';")
        webView.stringByEvaluatingJavaScript(from: fillForm)
    } */

}
