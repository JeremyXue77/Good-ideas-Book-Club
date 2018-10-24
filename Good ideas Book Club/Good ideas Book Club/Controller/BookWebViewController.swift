//
//  BookWebViewController.swift
//  Good ideas Book Club
//
//  Created by JeremyXue on 2018/10/17.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit
import WebKit

class BookWebViewController: UIViewController, WKUIDelegate {
    
    var urlString: String?

    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        if let string = urlString, let url = URL(string: string) {
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AnimationLoadingView.remove()
    }
    
}

extension BookWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        AnimationLoadingView.startLoading(message: "加載中...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        AnimationLoadingView.endLoading(message: "載入完成！")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        AnimationLoadingView.endLoading(message: "載入失敗！")
    }
}
