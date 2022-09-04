//
//  HtmlView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import WebKit

/// The HTML View
struct HtmlView: UIViewRepresentable {
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
