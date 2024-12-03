//
//  WebViewController.swift
//
//
//  Created by ウルトラ深瀬 on 3/12/24.
//

import UIKit
import WebKit

public protocol WebViewSDKInterface {
    func openWebView(withPresenting presentingVewController: UIViewController)
}

public final class WebViewSDK: WebViewSDKInterface {
    public init() {}
    
    public func openWebView(withPresenting presentingVewController: UIViewController) {
        print("sdk openWebView withPresenting: \(presentingVewController)")
        let vc = WebViewController()
        vc.modalPresentationStyle = .fullScreen
        presentingVewController.present(vc, animated: true)
    }
}

final class WebViewController: UIViewController {
    private var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "dismissVC")
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
        
        guard let url = URL(string: "https://takamasa-fukase.github.io/Sample_WebView_App/test_web_view.html") else { return }
        let request = URLRequest(url: url)
        webView?.load(request)
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("sdk didReceive message: \(message)")
        if message.name == "dismissVC",
           message.body as? String == "close" {
            print("sdk closeだった")
            dismiss(animated: true)
            
        } else {
            print("sdk closeじゃない")
        }
    }
}
