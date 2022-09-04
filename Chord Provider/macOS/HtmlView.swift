//
//  HtmlView.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import WebKit

/// The HTML View
struct HtmlView: NSViewRepresentable {
    
    var html: String

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.autoresizingMask = [.width, .height]
        webView.setValue(false, forKey: "drawsBackground")
        webView.setValue(true, forKey: "allowsMagnification")
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
