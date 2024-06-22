//
//  CGRect+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension CGRect {

    /// macOS version of `inset(by:)` from iOS
    func inset(by insets: NSEdgeInsets) -> NSRect {
        var rect = self
        rect.origin.x += insets.left
        rect.origin.y += insets.top
        rect.size.width -= (insets.left + insets.right)
        rect.size.height -= (insets.top + insets.bottom)
        return rect
    }
}
