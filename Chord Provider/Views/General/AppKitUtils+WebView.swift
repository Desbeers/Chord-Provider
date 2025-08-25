//
//  AppKitUtils+WebView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import SwiftUI
import WebKit

/// The HTML View
struct WKWebRepresentedView: NSViewRepresentable {

    var html: String

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

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    /// Custom Coordinator which handles persistent scroll position in the WebView
    class Coordinator: NSObject, WKNavigationDelegate {
        private var scrollPosition = CGPoint()

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
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
