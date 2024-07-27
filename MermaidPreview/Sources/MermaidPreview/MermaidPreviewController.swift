//
//  File.swift
//  
//
//  Created by bsorrentino on 26/07/24.
//

import Foundation
import UIKit
import WebKit

fileprivate class ScriptQueue {
    
    var _scripts:Array<String> = []
    
    var elements:Array<String> {
        get { _scripts }
    }
    
    var isEmpty:Bool {
        _scripts.isEmpty
    }
    
    func push( _ item: String ) {
        _scripts.append( item )
    }
    
    func pop() -> String? {
        guard  !_scripts.isEmpty else {
            return nil
        }
        
        return _scripts.removeLast()
    }
    
    public func clear() {
        _scripts.removeAll()
    }
    
}

public class MermaidPreviewController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    
    private var executionQueue = ScriptQueue()
    
    
    public override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.userContentController.add(UpdateTextScriptHandler(self), name: "updateText")
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .none
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } 
        /// [WKWebview Origin null is not allowed by Access-Control-Allow-Origin](https://stackoverflow.com/a/52634909/521197)
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        view = webView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebAssets()
    }
    
    private func loadWebAssets() {
        let myURL = Bundle.module.url(forResource: "index", withExtension: "html", subdirectory: "_Resources")
        
//        let myRequest = URLRequest(url: myURL!)
        guard let myURL else {
            fatalError( "index.html not found!")
        }

        webView.loadFileURL(myURL, allowingReadAccessTo: myURL.deletingLastPathComponent() )
        
    }
    
    // MARK: - WKWebView
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print( #function, "isLoading: \(webView.isLoading)" )

        while( !executionQueue.isEmpty ) {
            evaluateJavascript(executionQueue.pop()!)
        }
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print( #function )
    }
            
    func requestUpdate( text: String ) {
        print( #function, "isLoading: \(webView.isLoading)" )

        let javascript =
"""
document.getElementById('preview1')
    .dispatchEvent( new CustomEvent( 'graph', { detail:`\(text)` } ) );
"""
        evaluateJavascript(javascript)

    }
    

    private func evaluateJavascript(_ javascript: String) {

        guard !webView.isLoading  else {
            executionQueue.push( javascript )
            return;
        }
        
        webView.evaluateJavaScript(javascript, in: nil, in: WKContentWorld.page) {
        result in
          switch result {
          case .failure(let error):        
            var errorDescription = error.localizedDescription
            if let err = error as NSError?, let desc = err.userInfo["WKJavaScriptExceptionMessage"] as? String {
                errorDescription = desc
            }
            let alert = UIAlertController(title: "Error",
                                          message: "Something went wrong while evaluating\n\(errorDescription)",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
          case .success(_):
            break
          }
        }
    }

}
