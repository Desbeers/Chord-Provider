//
//  MacEditor.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

#if os(macOS)

import AppKit

/// The **ChordPro** editor for macOS
enum MacEditor {

    /// The lineheight multiplier for the editpr text
    static let lineHeightMultiple: Double = 1.4

    /// The style of a number in the ruler
    static var rulerNumberStyle: StringAttributes {
        let lineNumberStyle = NSMutableParagraphStyle()
        lineNumberStyle.alignment = .right
        lineNumberStyle.tailIndent = -2

        var fontAttributes: StringAttributes = [:]

        fontAttributes[NSAttributedString.Key.paragraphStyle] = lineNumberStyle
        fontAttributes[NSAttributedString.Key.backgroundColor] = NSColor.clear
        fontAttributes[NSAttributedString.Key.foregroundColor] = highlightedForegroundColor

        return fontAttributes
    }

    /// The foreground of the highlighted line in the editor
    static let highlightedForegroundColor: NSColor = NSColor.textColor.withAlphaComponent(0.3)

    /// The background of the highlighted line in the editor
    static let highlightedBackgroundColor: NSColor = NSColor.textColor.withAlphaComponent(0.03)
}

/// The delegate for the ``MacEditor``
// swiftlint:disable:next class_delegate_protocol
protocol MacEditorDelegate {
    func selectionNeedsDisplay()
}

#endif
