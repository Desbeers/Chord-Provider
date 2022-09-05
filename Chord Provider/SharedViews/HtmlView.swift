//
//  HtmlView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import WebKit

// MARK: - typealias: Get the correct function for macOS and iOS

#if os(macOS)
    typealias SWIFTViewRepresentable = NSViewRepresentable
#endif
#if os(iOS)
    typealias SWIFTViewRepresentable = UIViewRepresentable
#endif

/// The HTML View
struct HtmlView: SWIFTViewRepresentable {
    
    var html: String
    
#if os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.autoresizingMask = [.width, .height]
        webView.setValue(false, forKey: "drawsBackground")
        webView.setValue(true, forKey: "allowsMagnification")
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
#endif

#if os(iOS)
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
#endif

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    /// Custom Coordinator which handles persistent scroll position in the WebView
    class Coordinator: NSObject, WKNavigationDelegate {
        private var scrollPosition = CGPoint()
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            webView.evaluateJavaScript("[scrollLeft = window.pageXOffset || document.documentElement.scrollLeft, scrollTop = window.pageYOffset || document.documentElement.scrollTop]") { [weak self] value, _ in
                guard let value = value as? [Int] else {
                    return
                }
                self?.scrollPosition = CGPoint(x: value[0], y: value[1])
            }
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("""
            document.documentElement.scrollLeft = document.body.scrollLeft = \(scrollPosition.x)
            """)
            webView.evaluateJavaScript("""
            document.documentElement.scrollTop = document.body.scrollTop = \(scrollPosition.y)
            """)
        }
    }
}
