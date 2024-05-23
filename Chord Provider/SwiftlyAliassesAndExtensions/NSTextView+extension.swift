//
//  NSTextView+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

#if os(macOS)

import AppKit

extension NSTextView {

    /// macOS version of the `UIGraphicsGetCurrentContext` function from iOS
    /// - Returns: An optional Quartz 2D drawing environment
    func UIGraphicsGetCurrentContext() -> CGContext? {
        NSGraphicsContext.current?.cgContext
    }

    /// Get the selected text from the NSTextView
    /// - Note: This needs a `String` extension
    var selectedText: String {
        string[selectedRange()]
    }
}
#endif
