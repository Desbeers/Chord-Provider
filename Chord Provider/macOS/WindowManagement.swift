//
//  WindowManagement.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

extension View {

    /// Find the NSWindow of the scene
    /// - Parameter callback: The optional `NSWindow`
    /// - Returns: A SwiftUI `background` View
    func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(NSWindow.HostingWindowFinder(callback: callback))
    }
}

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

    /// The structure of an open window
    struct WindowItem {
        /// The ID of the `Window`
        let windowID: Int
        /// The URL of the ChordPro document
        var fileURL: URL?
    }
}
