//
//  NSWindow+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension NSWindow {

    /// Find the NSWindow of the scene
    struct HostingWindowFinder: NSViewRepresentable {
        /// The optional `NSWindow`
        var callback: (NSWindow?) -> Void
        func makeNSView(context: Context) -> NSView {
            let view = NSView()
            Task { @MainActor in
                callback(view.window)
            }
            return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
    }
}
