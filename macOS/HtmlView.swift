import SwiftUI
import WebKit

struct HtmlView: NSViewRepresentable {
    
    var html: String

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.autoresizingMask = [.width, .height]
        webView.setValue(false, forKey: "drawsBackground")
        webView.setValue(true, forKey: "allowsMagnification")
        webView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateNSView(_ webView: WKWebView, context: Context) {
        //let song = ChordPro.parse(text)
        //let html = buildHtml(song: song)
        webView.loadHTMLString(html, baseURL: nil)
    }



    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}


