//
//  File.swift
//  
//
//  Created by bsorrentino on 26/07/24.
//

import Foundation
import UIKit
import WebKit

public class MermaidPreviewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        
//        webConfiguration.userContentController.add(UpdateTextScriptHandler(self), name: "updateText")
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .none
        view = webView
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebAssets()
    }
    
    private func loadWebAssets() {
//        let myURL = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "_Resources")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
    }

}
