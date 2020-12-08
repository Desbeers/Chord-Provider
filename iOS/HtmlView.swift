//
//  PreviewView.swift
//  SongPro Editor
//
//  Created by Brian Kelly on 6/29/20.
//  Copyright © 2020 SongPro. All rights reserved.
//

import SwiftUI
import WebKit

struct HtmlView: UIViewRepresentable {
    var html: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .systemBackground
        //webView.isOpaque = false
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}

func GetAccentColor() -> String {
    return UIColor.systemBlue.hexString
}

func GetHighlightColor() -> String {
    return UIColor.systemBlue.hexString + "33"
}

func GetTextColor() -> String {
    return UIColor.label.hexString
}

func GetSystemBackground() -> String {
    return UIColor.systemBackground.hexString
}

extension UIColor {
    var hexString: String{
        let rgbColor = self
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb:Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }
}
