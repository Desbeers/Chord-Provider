//
//  Extensions+StyleInfo.swift
//  SourceEditor
//
//  © 2026 Nick Berendsen
//

import CAdw

extension Array where Element == Editor.StyleInfo {

    /// Look up the info of a style ID.
    /// - Parameter id: The `StyleID`.
    /// - Returns: The style info, or nil if the scheme does not define it.
    public subscript(id: Editor.StyleID) -> Editor.StyleInfo? {
        first { $0.id == id }
    }
}

extension Array where Element == Editor.StyleInfo {

    /// Look up the accent color.
    ///
    /// Tried in this order:
    /// - Color as set by the scheme.
    /// - A full opaque selection color from the scheme.
    /// - The system accent color.
    public var accent: Color {
        self[.accent]?.background ?? self[.selection]?.background.withAlpha(1) ?? Color.systemAccent
    }

    /// Bool if the scheme background is dark.
    public var isDark: Bool {
        guard
            let background = self[.text]?.background
        else {
            return false
        }
        return background.luminance < 0.5
    }
}
