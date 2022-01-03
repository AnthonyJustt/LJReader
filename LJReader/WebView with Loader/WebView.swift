//
//  WebView.swift
//  SwiftUIWebView
//
//  Created by Md. Yamin on 4/25/20.
//  Copyright © 2020 Md. Yamin. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

struct WebView: UIViewRepresentable{
    var url: WebURLType
    var StringURL: String
    // Viewmodel object
    @ObservedObject var viewModel: ViewModel
    
    // Make a coordinator to co-ordinate with WKWebView's default delegate functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Enable javascript in WKWebView
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        webView.isOpaque = false // для темной темы, чтобы задний фон не был белым
        webView.backgroundColor = UIColor.clear  // для темной темы, чтобы задний фон не был белым
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        switch url {
        case .publicURL:
            // Load public website
            if let url = URL(string: "https://www.google.com") {
                webView.load(URLRequest(url: url))
            }
        case .parsedURL:
            // Load parsed website
            webView.loadHTMLString(fparseArticle(fhtml: fname(furl: StringURL)), baseURL: nil)
        }
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: WebView
        var webViewNavigationSubscriber: AnyCancellable? = nil
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
        }
        
        deinit {
            webViewNavigationSubscriber?.cancel()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.parent.viewModel.showLoader.send(false)
            
            // turning web page dark by inverting colors for dark mode
            let css = "@media (prefers-color-scheme: dark) { html{ filter: invert(1)  hue-rotate(.5turn); } img { filter: invert(1)  hue-rotate(.5turn); } }"
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            webView.evaluateJavaScript(js, completionHandler: nil)
            // end of turning
        }
        
        /* Here I implemented most of the WKWebView's delegate functions so that you can know them and
         can use them in different necessary purposes */
        
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            // Hides loader
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Hides loader
            parent.viewModel.showLoader.send(false)
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            // Shows loader
            parent.viewModel.showLoader.send(true)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Shows loader
            parent.viewModel.showLoader.send(true)
            self.webViewNavigationSubscriber = self.parent.viewModel.webViewNavigationPublisher.receive(on: RunLoop.main).sink(receiveValue: { navigation in
                switch navigation {
                case .reload:
                    webView.reload()
                case .backward:
                    if webView.canGoBack {
                        webView.goBack()
                    }
                case .forward:
                    if webView.canGoForward {
                        webView.goForward()
                    }
                }
            })
        }
        
    }
}
