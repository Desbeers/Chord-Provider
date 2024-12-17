//
//  ChordProEditor+Static.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import SwiftUI

extension ChordProEditor {

    // MARK: Static settings for the editor

    /// The style of a number in the ruler
    static var rulerNumberStyle: [NSAttributedString.Key: Any] {
        let lineNumberStyle = NSMutableParagraphStyle()
        lineNumberStyle.alignment = .right
        lineNumberStyle.lineHeightMultiple = Editor.lineHeightMultiple
        var fontAttributes: [NSAttributedString.Key: Any] = [:]
        fontAttributes[NSAttributedString.Key.paragraphStyle] = lineNumberStyle
        return fontAttributes
    }

    /// The foreground of the highlighted line in the editor
    /// - Note: A `var` to keep it up-to-date when the accent color is changed
    static var highlightedForegroundColor: NSColor {
        return .controlAccentColor.withAlphaComponent(0.06)
    }

    /// The background of the highlighted line in the editor
    static let highlightedBackgroundColor: NSColor = .gray.withAlphaComponent(0.1)
}
