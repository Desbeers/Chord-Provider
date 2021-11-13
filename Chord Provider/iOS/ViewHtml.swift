// MARK: - UIViewRepresentable: HTML view  for iOS

import SwiftUI
import WebKit

struct ViewHtml: UIViewRepresentable {
    var html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
